#!/usr/bin/env python3
"""
save_videos_ui.py

Flask UI wrapper with live status/progress for saving videos into SAVE_ROOT
and zipping them for download. Modified from save_images_ui.py to support video downloads.

Flow:
 - POST /start-job  -> starts a background job for selected task ids, returns job id
 - GET  /status/<jobid> -> page with SSE that shows live status and final download link
 - GET  /stream/<jobid> -> SSE stream of status updates
 - GET  /download_job/<jobid> -> serves the produced zip
"""

import os
import time
import base64
import re
import random
import requests
import json
import shutil
import tempfile
import zipfile
import threading
import uuid
from typing import Tuple, Optional, Any, List
from flask import Flask, render_template_string, request, send_file, redirect, url_for, flash, Response, jsonify

# ---------------- CONFIG ----------------
API_BASE = "http://127.0.0.1:8000/api"
POLL_INTERVAL_SECONDS = 8

PENDING_DIR = r"C:\Users\yuvra\Downloads\compautosend\compautosend\autosend\PENDING_DIR"
PENDING_DIR = os.path.abspath(PENDING_DIR)
SAVE_ROOT = PENDING_DIR

REQUEST_TIMEOUT = 60  # Increased for videos
USER_AGENT = "SaveImagesByGroup/1.4"
MAX_RETRIES = 6
INITIAL_BACKOFF = 1.0
MAX_BACKOFF = 60.0
JITTER_FACTOR = 0.25
MIN_INTERVAL_BETWEEN_REQUESTS = 0.4
BAD_VIDEO_IDS_FILE = os.path.join(SAVE_ROOT, "bad_video_ids.json")
# ----------------------------------------

session = requests.Session()
session.headers.update({"User-Agent": USER_AGENT, "Accept": "application/json"})

_last_request_time = 0.0
bad_video_ids = set()

# ---------------- Job tracking ----------------
job_status = {}
job_status_lock = threading.Lock()

def emit_job_message(jobid: str, msg: str):
    with job_status_lock:
        if jobid not in job_status:
            job_status[jobid] = {"status": "running", "messages": [], "zip_path": None, "error": None}
        job_status[jobid]["messages"].append(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {msg}")

def set_job_done(jobid: str, zip_path: Optional[str]):
    with job_status_lock:
        js = job_status.setdefault(jobid, {"status": "running", "messages": [], "zip_path": None, "error": None})
        js["status"] = "done"
        js["zip_path"] = zip_path

def set_job_error(jobid: str, error_msg: str):
    with job_status_lock:
        js = job_status.setdefault(jobid, {"status": "running", "messages": [], "zip_path": None, "error": None})
        js["status"] = "error"
        js["error"] = error_msg
        js["messages"].append(f"[ERROR] {error_msg}")

def get_job_snapshot(jobid: str):
    with job_status_lock:
        return job_status.get(jobid, {"status": "unknown", "messages": [], "zip_path": None, "error": None})

# ---------------- Helper functions ----------------

def load_bad_video_ids():
    global bad_video_ids
    try:
        if os.path.exists(BAD_VIDEO_IDS_FILE):
            with open(BAD_VIDEO_IDS_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
                if isinstance(data, list):
                    bad_video_ids = set(int(x) for x in data if isinstance(x, (int, str)) and str(x).isdigit())
                elif isinstance(data, dict):
                    lst = data.get("ids") or data.get("bad_video_ids") or []
                    if isinstance(lst, list):
                        bad_video_ids = set(int(x) for x in lst if isinstance(x, (int, str)) and str(x).isdigit())
    except Exception as e:
        print(f"[WARN] Could not load bad_video_ids from {BAD_VIDEO_IDS_FILE}: {e}")
        bad_video_ids = set()

def save_bad_video_ids():
    try:
        os.makedirs(SAVE_ROOT, exist_ok=True)
        with open(BAD_VIDEO_IDS_FILE, "w", encoding="utf-8") as f:
            json.dump(sorted(list(bad_video_ids)), f, indent=2)
    except Exception as e:
        print(f"[WARN] Could not save bad_video_ids to {BAD_VIDEO_IDS_FILE}: {e}")

def _throttle():
    global _last_request_time
    now = time.time()
    elapsed = now - _last_request_time
    if elapsed < MIN_INTERVAL_BETWEEN_REQUESTS:
        time.sleep(MIN_INTERVAL_BETWEEN_REQUESTS - elapsed)
    _last_request_time = time.time()

def _compute_backoff(attempt: int) -> float:
    backoff = min(MAX_BACKOFF, INITIAL_BACKOFF * (2 ** (attempt - 1)))
    jitter = backoff * JITTER_FACTOR
    return max(0.0, backoff + random.uniform(-jitter, jitter))

def request_with_retries(method: str, url: str, retries: Optional[int] = None, **kwargs):
    last_exception = None
    max_attempts = retries if (isinstance(retries, int) and retries > 0) else MAX_RETRIES
    for attempt in range(1, max_attempts + 1):
        try:
            _throttle()
            if method.lower() == "get":
                resp = session.get(url, timeout=REQUEST_TIMEOUT, **kwargs)
            elif method.lower() == "post":
                resp = session.post(url, timeout=REQUEST_TIMEOUT, **kwargs)
            else:
                raise ValueError("Unsupported method: " + method)

            if resp.status_code == 429:
                retry_after = resp.headers.get("Retry-After")
                if retry_after:
                    try:
                        wait = int(retry_after)
                    except Exception:
                        try:
                            wait = float(retry_after)
                        except Exception:
                            wait = _compute_backoff(attempt)
                    print(f"[WARN] 429 for {url} — Retry-After {wait}s (attempt {attempt}/{max_attempts})")
                    time.sleep(wait + random.uniform(0, 1.0))
                else:
                    backoff = _compute_backoff(attempt)
                    print(f"[WARN] 429 for {url} — backing off {backoff:.1f}s (attempt {attempt}/{max_attempts})")
                    time.sleep(backoff)
                last_exception = requests.HTTPError(f"429 Too Many Requests for {url}")
                continue

            if 500 <= resp.status_code < 600:
                backoff = _compute_backoff(attempt)
                print(f"[WARN] {resp.status_code} server error for {url} — retrying in {backoff:.1f}s (attempt {attempt}/{max_attempts})")
                time.sleep(backoff)
                last_exception = requests.HTTPError(f"{resp.status_code} Server Error for {url}")
                continue

            resp.raise_for_status()
            return resp

        except requests.RequestException as e:
            backoff = _compute_backoff(attempt)
            print(f"[WARN] Request exception for {url}: {e} — retrying in {backoff:.1f}s (attempt {attempt}/{max_attempts})")
            last_exception = e
            time.sleep(backoff)

    raise last_exception or Exception("Unknown error in request_with_retries")

def safe_folder_name(name: str) -> str:
    if not name:
        return "unknown_group"
    n = name.strip()
    n = re.sub(r'[\\/:"*?<>|]+', "_", n)
    n = re.sub(r"\s+", " ", n)
    if len(n) > 120:
        n = n[:120].rstrip()
    return n or "group"

def get_task_list():
    url = f"{API_BASE}/video-task-list"
    resp = request_with_retries("get", url)
    return resp.json()

def get_video_list(taskid: int):
    """Fetch list of generated videos for a task"""
    url = f"{API_BASE}/generated-videos-list?taskId={taskid}"
    resp = request_with_retries("get", url)
    return resp.json()

def _find_first_dict(obj: Any) -> Optional[dict]:
    if isinstance(obj, dict):
        return obj
    if isinstance(obj, list):
        for item in obj:
            found = _find_first_dict(item)
            if found is not None:
                return found
    return None

def fetch_video_metadata(taskid: int, videoid: int) -> Tuple[str, Optional[str], Optional[str]]:
    """Fetch video URL and metadata from generated_videos table"""
    if videoid in bad_video_ids:
        raise ValueError(f"Video {videoid} is blacklisted (previously failed)")

    url = f"{API_BASE}/generated-videos-list?taskId={taskid}"
    resp = request_with_retries("get", url)
    payload = resp.json()
    
    videos = payload.get("videos", [])
    video_data = None
    for v in videos:
        if v.get("id") == videoid:
            video_data = v
            break
    
    if not video_data:
        raise ValueError(f"Video {videoid} not found in task {taskid}")
    
    video_url = video_data.get("video_url")
    filename = video_data.get("video_name")
    customer_name = video_data.get("customer_name") or "unknown_customer"
    
    if not video_url:
        raise ValueError(f"No video URL for videoid {videoid}")
    
    return video_url, filename, customer_name

def download_video_file(video_url: str, output_path: str):
    """Download video from URL to local path with progress"""
    _throttle()
    resp = session.get(video_url, timeout=REQUEST_TIMEOUT, stream=True)
    resp.raise_for_status()
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    with open(output_path, 'wb') as f:
        for chunk in resp.iter_content(chunk_size=8192):
            if chunk:
                f.write(chunk)

def update_video_status(videoid: int):
    """Mark video as sent"""
    url = f"{API_BASE}/update-video-status"
    payload = {"videoId": videoid}
    resp = request_with_retries("post", url, json=payload)
    try:
        return resp.json()
    except Exception:
        return resp.text

# ---------------- High-level processing for videos ----------------

def process_selected_tasks_to_saveroot_job(task_ids: List[int], jobid: str) -> List[str]:
    """
    Background worker: downloads videos to SAVE_ROOT/<customer_name>/filename,
    updates job_status via emit_job_message, and returns list of saved file paths.
    Videos are organized by customer name into separate folders.
    """
    saved_files = []
    os.makedirs(SAVE_ROOT, exist_ok=True)
    emit_job_message(jobid, f"Starting processing {len(task_ids)} video task(s): {task_ids}")

    for taskidx, taskid in enumerate(task_ids, start=1):
        emit_job_message(jobid, f"Fetching videos for task {taskid} ({taskidx}/{len(task_ids)})")
        try:
            response = get_video_list(taskid)
        except Exception as e:
            emit_job_message(jobid, f"ERROR fetching video-list for task {taskid}: {e}")
            continue

        videos = response.get("videos", [])
        if not videos:
            emit_job_message(jobid, f"No videos for task {taskid}")
            continue

        for vid in videos:
            videoid = vid.get("id")
            if not videoid:
                continue
            
            try:
                videoid_int = int(videoid)
            except Exception:
                videoid_int = None

            sent_flag = vid.get("sent", 0)
            if sent_flag:
                emit_job_message(jobid, f"Skipping video {videoid} (already sent)")
                continue
            if videoid_int is not None and videoid_int in bad_video_ids:
                emit_job_message(jobid, f"Skipping video {videoid} (blacklisted)")
                continue

            video_url = vid.get("video_url")
            filename = vid.get("video_name")
            # Extract customer name from API response
            customer_name = vid.get("customer_name") or "unknown_customer"

            if not video_url:
                emit_job_message(jobid, f"ERROR: No video URL for video {videoid}")
                continue

            if not filename:
                filename = f"video_{videoid}.mp4"

            # Create customer-specific folder
            folder = safe_folder_name(customer_name)
            out_dir = os.path.join(SAVE_ROOT, folder)
            
            save_path = os.path.join(out_dir, filename)
            # Handle duplicates
            base, ext = os.path.splitext(save_path)
            counter = 1
            while os.path.exists(save_path):
                save_path = f"{base}_{counter}{ext}"
                counter += 1

            try:
                emit_job_message(jobid, f"Downloading video {videoid} for customer '{customer_name}'")
                download_video_file(video_url, save_path)
                saved_files.append(save_path)
                emit_job_message(jobid, f"✓ Saved to: {folder}/{os.path.basename(save_path)}")
            except Exception as e:
                emit_job_message(jobid, f"ERROR downloading video {videoid}: {e}")
                try:
                    if videoid_int:
                        bad_video_ids.add(videoid_int)
                        save_bad_video_ids()
                except Exception:
                    pass
                continue

            # Update status on server
            try:
                if videoid_int:
                    resp = update_video_status(videoid_int)
                    emit_job_message(jobid, f"Marked video {videoid} as sent")
            except Exception as e:
                emit_job_message(jobid, f"ERROR updating status for video {videoid}: {e}")

    emit_job_message(jobid, f"Finished fetching videos. {len(saved_files)} file(s) saved across customer folders.")
    
    if saved_files:
        zip_fname = f"videos_tasks_{jobid}_{int(time.time())}.zip"
        zip_path = os.path.join(tempfile.gettempdir(), zip_fname)
        try:
            with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
                for f in saved_files:
                    try:
                        # Preserve customer folder structure in ZIP
                        arcname = os.path.relpath(f, SAVE_ROOT)
                    except Exception:
                        arcname = os.path.basename(f)
                    zf.write(f, arcname)
            emit_job_message(jobid, f"ZIP created with customer folders: {zip_path}")
            set_job_done(jobid, zip_path)
        except Exception as e:
            emit_job_message(jobid, f"ERROR creating ZIP: {e}")
            set_job_error(jobid, f"ZIP error: {e}")
    else:
        emit_job_message(jobid, "No files saved, nothing to zip.")
        set_job_done(jobid, None)

# ---------------- Flask UI ----------------

app = Flask(__name__)
app.secret_key = "change_this_to_something_secret_in_prod"

TASKS_TEMPLATE = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Save Videos UI</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .panel { display: flex; gap: 20px; align-items: flex-start; }
    .col { flex: 1; min-width: 240px; }
    .task-list { border: 1px solid #ddd; padding: 8px; border-radius:6px; max-height: 360px; overflow: auto; }
    .task { padding: 8px; border-bottom: 1px solid #f0f0f0; }
    .controls { margin-top: 12px; }
    .btn { padding: 8px 12px; border-radius: 4px; background: #007bff; color: white; text-decoration:none; display:inline-block; border: none; cursor: pointer; }
    .btn:disabled { background: #aaa; cursor: not-allowed; }
    .small { font-size: 0.9em; color: #555; }
  </style>
</head>
<body>
  <h2>Video Tasks (Generated & Ready to Download)</h2>
  {% if not tasks %}
    <p>No video tasks found. Tasks must be generated (status=1) to appear here.</p>
  {% else %}
    <form id="start_form" method="post" action="{{ url_for('start_job') }}">
      <div class="panel">
        <div class="col">
          <div>
            <label><input type="checkbox" id="select_all" onchange="toggleAll(this)"> <strong>Select / Deselect All</strong></label>
          </div>
          <div style="margin-top:12px;" class="task-list" id="checkbox_container">
            {% for t in tasks %}
              <div class="task">
                <label>
                  <input type="checkbox" name="taskid" value="{{ t['id'] }}">
                  <strong>{% if t.get('taskname') %}{{ t.get('taskname') }}{% else %}Task {{ t.get('id') }}{% endif %}</strong> — 
                  Total: {{ t.get('totalvideos', 0) }}, Sent: {{ t.get('send', 0) }}, Pending: {{ t.get('pending', 0) }} — ID: {{ t.get('id') }}
                </label>
              </div>
            {% endfor %}
          </div>
        </div>
      </div>

      <div class="controls">
        <button type="submit" class="btn">Start download job for selected</button>
        <button type="button" class="btn" onclick="clearSelection()" style="background:#6c757d;margin-left:8px;">Clear selection</button>
        <a href="{{ url_for('index') }}" class="btn" style="background:#28a745;margin-left:8px;">Refresh</a>
      </div>
    </form>
  {% endif %}
<script>
function toggleAll(chk) {
  const boxes = document.querySelectorAll('input[name="taskid"][type="checkbox"]');
  boxes.forEach(b => b.checked = chk.checked);
}

document.getElementById('start_form')?.addEventListener('submit', function(e) {
  e.preventDefault();
  const form = e.target;
  const data = new FormData(form);
  fetch(form.action, { method: 'POST', body: data })
    .then(r => r.json())
    .then(j => {
      if (j.jobid) {
        window.location = '/status/' + j.jobid;
      } else {
        alert('Failed to start job');
      }
    })
    .catch(err => {
      alert('Error starting job: ' + err);
    });
});

function clearSelection() {
  const boxes = document.querySelectorAll('input[name="taskid"][type="checkbox"]');
  boxes.forEach(b => b.checked = false);
  document.getElementById('select_all').checked = false;
}
</script>
</body>
</html>
"""

STATUS_TEMPLATE = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Job status - {{ jobid }}</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    #log { border:1px solid #ddd; padding:12px; height: 400px; overflow:auto; white-space: pre-wrap; background:#fafafa; }
    .btn { padding:8px 12px; border-radius:4px; background:#007bff; color:white; text-decoration:none; border:none; cursor:pointer; }
  </style>
</head>
<body>
  <h3>Job: {{ jobid }}</h3>
  <div id="log">Connecting...</div>
  <div style="margin-top:12px;">
    <a id="download_link" style="display:none;" class="btn" href="#">Download ZIP</a>
    <a href="/" class="btn" style="background:#6c757d;margin-left:8px;">Back</a>
  </div>

<script>
const logEl = document.getElementById('log');
const downloadLink = document.getElementById('download_link');
const evtSource = new EventSource("{{ url_for('stream', jobid=jobid) }}");

evtSource.onmessage = function(e) {
  try {
    const payload = JSON.parse(e.data);
    if (payload.type === 'message') {
      logEl.textContent += payload.text + "\\n";
      logEl.scrollTop = logEl.scrollHeight;
    } else if (payload.type === 'status') {
      logEl.textContent += "[STATUS] " + payload.status + "\\n";
      if (payload.status === 'done') {
        if (payload.zip_path) {
          downloadLink.href = "/download_job/" + payload.jobid;
          downloadLink.style.display = "inline-block";
        } else {
          logEl.textContent += "No ZIP was produced for this job.\\n";
        }
        evtSource.close();
      } else if (payload.status === 'error') {
        evtSource.close();
      }
      logEl.scrollTop = logEl.scrollHeight;
    }
  } catch (ex) {
    logEl.textContent += e.data + "\\n";
    logEl.scrollTop = logEl.scrollHeight;
  }
};

evtSource.onerror = function(e) {
  logEl.textContent += "[SSE] Connection error or closed.\\n";
  evtSource.close();
};
</script>
</body>
</html>
"""

# --------------------------------------------------------------------------
# Routes
# --------------------------------------------------------------------------

@app.route("/", methods=["GET"])
def index():
    load_bad_video_ids()
    try:
        tasks_resp = get_task_list()
    except Exception as e:
        flash(f"Error fetching task-list: {e}", "error")
        tasks_resp = []

    pending_tasks = []
    if isinstance(tasks_resp, list):
        pending_tasks = tasks_resp
    elif isinstance(tasks_resp, dict):
        if "data" in tasks_resp:
            pending_tasks = tasks_resp["data"]
        elif "tasks" in tasks_resp:
            pending_tasks = tasks_resp["tasks"]

    # Filter for video tasks that are generated but not sent (status=1, sent_status=0)
    to_show = []
    for t in pending_tasks:
        # API already returns only video tasks, so no need to filter by task_type
        
        # Show tasks that are:
        # 1. Generated (status = 1)
        # 2. Not fully sent (sent_status = 0 or totalvideos > send)
        # 3. OR have pending videos (pending > 0)
        
        status = t.get("status", 0)
        sent_status = t.get("sent_status", 0)
        total_videos = t.get("totalvideos", 0)
        sent_count = t.get("send", 0)
        pending_count = t.get("pending", 0)
        
        # Include if: generated and not fully sent, OR has pending videos
        should_include = False
        if status == 1 and sent_status == 0:  # Generated but not marked as sent
            should_include = True
        elif total_videos > sent_count:  # Has unsent videos
            should_include = True
        elif pending_count > 0:  # Has pending videos
            should_include = True
        
        if should_include:
            tid = t.get("id")
            if tid:
                t['id'] = tid
                to_show.append(t)

    try:
        to_show_sorted = sorted(to_show, key=lambda x: int(x.get("id")), reverse=True)
    except Exception:
        to_show_sorted = list(reversed(to_show))

    return render_template_string(TASKS_TEMPLATE, tasks=to_show_sorted)

@app.route("/start-job", methods=["POST"])
def start_job():
    selected = request.form.getlist("taskid")
    if not selected:
        return jsonify({"error": "No tasks selected."}), 400
    
    task_ids = []
    for s in selected:
        try:
            task_ids.append(int(s))
        except Exception:
            pass
    
    if not task_ids:
        return jsonify({"error": "No valid task ids selected."}), 400

    jobid = uuid.uuid4().hex
    with job_status_lock:
        job_status[jobid] = {"status": "running", "messages": [], "zip_path": None, "error": None}

    thread = threading.Thread(target=_job_thread_wrapper, args=(task_ids, jobid), daemon=True)
    thread.start()

    return jsonify({"jobid": jobid}), 200

def _job_thread_wrapper(task_ids: List[int], jobid: str):
    try:
        process_selected_tasks_to_saveroot_job(task_ids, jobid)
    except Exception as e:
        set_job_error(jobid, str(e))

@app.route("/status/<jobid>", methods=["GET"])
def status(jobid):
    return render_template_string(STATUS_TEMPLATE, jobid=jobid)

@app.route("/stream/<jobid>")
def stream(jobid):
    def event_stream():
        last_index = 0
        while True:
            snapshot = get_job_snapshot(jobid)
            msgs = snapshot.get("messages", [])
            while last_index < len(msgs):
                m = msgs[last_index]
                data = json.dumps({"type": "message", "text": m})
                yield f"data: {data}\n\n"
                last_index += 1
            
            status = snapshot.get("status")
            if status in ("done", "error"):
                payload = {"type": "status", "status": status, "jobid": jobid, "zip_path": snapshot.get("zip_path")}
                yield f"data: {json.dumps(payload)}\n\n"
                break
            
            yield f": ping\n\n"
            time.sleep(1.0)
    return Response(event_stream(), mimetype="text/event-stream")

@app.route("/download_job/<jobid>")
def download_job(jobid):
    snapshot = get_job_snapshot(jobid)
    if snapshot.get("status") != "done":
        return "Job not ready", 404
    zip_path = snapshot.get("zip_path")
    if not zip_path or not os.path.exists(zip_path):
        return "ZIP not found", 404
    return send_file(zip_path, as_attachment=True, download_name=os.path.basename(zip_path))

# --------------------------------------------------------------------------
# Start app
# --------------------------------------------------------------------------
if __name__ == "__main__":
    os.makedirs(SAVE_ROOT, exist_ok=True)
    load_bad_video_ids()
    print("Starting Flask UI for Videos on http://127.0.0.1:5002")
    app.run(debug=True, host="127.0.0.1", port=5002)
