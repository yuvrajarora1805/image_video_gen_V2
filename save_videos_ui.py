#!/usr/bin/env python3
"""
save_videos_ui.py

Flask UI wrapper with live status/progress for saving generated VIDEOS into SAVE_ROOT
and zipping them for download.

Flow:
 - POST /start-job  -> starts a background job for selected task ids, returns job id
 - GET  /status/<jobid> -> page with SSE that shows live status and final download link
 - GET  /stream/<jobid> -> SSE stream of status updates
 - GET  /download_job/<jobid> -> serves the produced zip
"""

import os
import time
import requests
import json
import zipfile
import threading
import uuid
import re
import tempfile
import shutil
import concurrent.futures
from urllib.parse import urlparse
from typing import Tuple, Optional, Any, List
from flask import Flask, render_template_string, request, send_file, redirect, url_for, flash, Response, jsonify

# ---------------- CONFIG ----------------
# API_BASE should point to your Laravel API. Adjust if your XAMPP path differs.
API_BASE = "http://localhost/api" 

POLL_INTERVAL_SECONDS = 8
PENDING_DIR = r"H:\VIDEOS_DOWNLOAD_DIR"
PENDING_DIR = os.path.abspath(PENDING_DIR)
SAVE_ROOT = PENDING_DIR

# Try to detect local video path relative to this script
# Assumes script is in <root> and videos are in <root>/public/videos/generated_video
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# LOCAL_VIDEO_PATH = os.path.join(BASE_DIR, "public", "videos", "generated_video")
LOCAL_VIDEO_PATH = r"C:\xampp\htdocs\imgen\public_html\public\videos\generated_video"

REQUEST_TIMEOUT = 300 # Longer timeout for videos
USER_AGENT = "SaveVideosByGroup/1.0"
MAX_RETRIES = 6
INITIAL_BACKOFF = 1.0
MAX_BACKOFF = 60.0
JITTER_FACTOR = 0.25
MIN_INTERVAL_BETWEEN_REQUESTS = 0.4
BAD_VIDEO_IDS_FILE = os.path.join(SAVE_ROOT, "bad_video_ids.json")
MAX_WORKERS = 8 # Parallel download threads
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
                    bad_video_ids = set(int(x) for x in data if str(x).isdigit())
    except Exception as e:
        print(f"[WARN] Could not load bad_video_ids: {e}")
        bad_video_ids = set()

def save_bad_video_ids():
    try:
        os.makedirs(SAVE_ROOT, exist_ok=True)
        with open(BAD_VIDEO_IDS_FILE, "w", encoding="utf-8") as f:
            json.dump(sorted(list(bad_video_ids)), f, indent=2)
    except Exception as e:
        print(f"[WARN] Could not save bad_video_ids: {e}")

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
            resp = session.request(method, url, timeout=REQUEST_TIMEOUT, **kwargs)
            
            if resp.status_code == 429:
                time.sleep(_compute_backoff(attempt))
                continue
            if 500 <= resp.status_code < 600:
                time.sleep(_compute_backoff(attempt))
                continue

            resp.raise_for_status()
            return resp

        except requests.RequestException as e:
            time.sleep(_compute_backoff(attempt))
            last_exception = e

    raise last_exception or Exception("Unknown error in request_with_retries")

def safe_folder_name(name: str) -> str:
    if not name:
        return "unknown_group"
    n = name.strip()
    n = re.sub(r'[\\/:"*?<>|]+', "_", n)
    n = re.sub(r"\s+", " ", n)
    return n[:120].strip() or "group"

# --- API Methods ---

def get_video_task_list():
    """Fetches list of video tasks from /api/video-task-list"""
    url = f"{API_BASE}/video-task-list"
    resp = request_with_retries("get", url)
    return resp.json()

def get_generated_videos(taskid: int):
    """Fetches list of generated videos for a task from /api/generated-videos-list"""
    # Note: APIController expects 'taskId' (case sensitive check in PHP)
    url = f"{API_BASE}/generated-videos-list?taskId={taskid}"
    resp = request_with_retries("get", url)
    return resp.json()

def update_video_status(videoid: int):
    """Marks video as sent/downloaded via /api/update-video-status"""
    url = f"{API_BASE}/update-video-status"
    payload = {"videoId": videoid}
    resp = request_with_retries("post", url, json=payload)
    try:
        return resp.json()
    except Exception:
        return resp.text

def download_file(url: str, local_path: str):
    """Downloads a file from a URL to a local path with streaming"""
    with session.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192): 
                f.write(chunk)
    return local_path

# ---------------- Processing Logic ----------------

def process_single_video(vid, jobid):
    """Worker function to process a single video"""
    videoid = vid.get("id")
    if not videoid or videoid in bad_video_ids:
        return None

    video_url = vid.get("video_url")
    customer_name = vid.get("customer_name", "Unknown")
    video_name = vid.get("video_name", f"video_{videoid}.mp4")

    if not video_url:
        emit_job_message(jobid, f"No URL for video {videoid}")
        return None

    # Prepare output path
    group_name = customer_name 
    folder = safe_folder_name(group_name)
    out_dir = os.path.join(SAVE_ROOT, folder)
    os.makedirs(out_dir, exist_ok=True)
    save_path = os.path.join(out_dir, video_name)

    # Avoid overwriting
    if os.path.exists(save_path):
        base, ext = os.path.splitext(save_path)
        save_path = f"{base}_{int(time.time())}{ext}"

    # Optimization: Try to copy from local file system first
    filename = os.path.basename(urlparse(video_url).path)
    local_source = os.path.join(LOCAL_VIDEO_PATH, filename)
    
    success = False
    
    if os.path.exists(local_source):
        try:
            shutil.copy2(local_source, save_path)
            emit_job_message(jobid, f"Copied video {videoid} from local -> {save_path}")
            success = True
        except Exception as e:
            emit_job_message(jobid, f"Copy failed for {videoid}, fallback to download: {e}")
    
    if not success:
        # Fallback to download
        emit_job_message(jobid, f"Downloading video {videoid} from {video_url}...")
        try:
            download_file(video_url, save_path)
            emit_job_message(jobid, f"Downloaded video {videoid} -> {save_path}")
            success = True
        except Exception as e:
            emit_job_message(jobid, f"ERROR downloading video {videoid}: {e}")
            bad_video_ids.add(videoid)
            return None

    # Update status on server
    if success:
        try:
            update_video_status(videoid)
        except Exception as e:
            emit_job_message(jobid, f"Warning: Failed to update status for {videoid}: {e}")
        return save_path
    
    return None

def process_selected_tasks_to_saveroot_job(task_ids: List[int], jobid: str):
    saved_files = []
    os.makedirs(SAVE_ROOT, exist_ok=True)
    emit_job_message(jobid, f"Starting processing {len(task_ids)} video task(s): {task_ids}")
    emit_job_message(jobid, f"Parallel execution with {MAX_WORKERS} workers. Local video path check: {LOCAL_VIDEO_PATH}")

    all_videos = []
    
    # 1. Gather all videos to process
    for taskidx, taskid in enumerate(task_ids, start=1):
        emit_job_message(jobid, f"Fetching list for task {taskid}...")
        try:
            data = get_generated_videos(taskid)
            if data and data.get("success"):
                videos = data.get("videos", [])
                if videos:
                    emit_job_message(jobid, f"Task {taskid}: Found {len(videos)} videos.")
                    all_videos.extend(videos)
                else:
                    emit_job_message(jobid, f"Task {taskid}: No videos found.")
            else:
                 msg = data.get("message") if data else "Unknown error"
                 emit_job_message(jobid, f"Task {taskid} failed: {msg}")
        except Exception as e:
            emit_job_message(jobid, f"ERROR fetching videos for task {taskid}: {e}")

    # 2. Process concurrently
    if not all_videos:
        emit_job_message(jobid, "No videos to process.")
    else:
        emit_job_message(jobid, f"Queueing {len(all_videos)} videos for processing...")
        
        with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
            # Map each video to the worker
            future_to_video = {executor.submit(process_single_video, vid, jobid): vid for vid in all_videos}
            
            for future in concurrent.futures.as_completed(future_to_video):
                result_path = future.result()
                if result_path:
                    saved_files.append(result_path)

    emit_job_message(jobid, f"Finished. {len(saved_files)} videos saved.")
    
    if saved_files:
        zip_fname = f"videos_tasks_{jobid}_{int(time.time())}.zip"
        zip_path = os.path.join(tempfile.gettempdir(), zip_fname)
        try:
            emit_job_message(jobid, "Creating ZIP file... (this may take a while for large videos)")
            # Use compression=zipfile.ZIP_STORED for speed, as MP4s don't compress well
            with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_STORED) as zf:
                for f in saved_files:
                    try:
                        arcname = os.path.relpath(f, SAVE_ROOT)
                        zf.write(f, arcname)
                    except Exception as e:
                         print(f"Zip error for {f}: {e}")
            
            emit_job_message(jobid, f"ZIP created: {zip_path}")
            set_job_done(jobid, zip_path)
        except Exception as e:
            emit_job_message(jobid, f"ERROR creating ZIP: {e}")
            set_job_error(jobid, f"ZIP error: {e}")
    else:
        emit_job_message(jobid, "No videos saved.")
        set_job_done(jobid, None)

# ---------------- Flask UI ----------------

app = Flask(__name__)
app.secret_key = "video_downloader_secret_key"

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
  </style>
</head>
<body>
  <h2>Video Tasks</h2>
  {% if not tasks %}
    <p>No video tasks found.</p>
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
                  <input type="checkbox" name="taskid" value="{{ t['id'] }}" id="chk_{{ loop.index0 }}">
                  <strong>{{ t['taskname'] }}</strong><br>
                  <span style="font-size:0.9em;color:#666;">
                    ID: {{ t['id'] }} | Total: {{ t['totalvideos'] }} | Generated: {{ t['pending'] + t['send'] }} | Sent: {{ t['send'] }}
                  </span>
                </label>
              </div>
            {% endfor %}
          </div>
        </div>
      </div>
      <div class="controls">
        <button type="submit" class="btn">Download Selected Tasks</button>
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
        alert('Failed to start job: ' + (j.error || 'Unknown error'));
      }
    })
    .catch(err => {
      alert('Error starting job: ' + err);
    });
});
</script>
</body>
</html>
"""

STATUS_TEMPLATE = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8"/>
  <title>Job Status - {{ jobid }}</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    #log { border:1px solid #ddd; padding:12px; height: 400px; overflow:auto; white-space: pre-wrap; background:#fafafa; }
    .btn { padding:8px 12px; border-radius:4px; background:#007bff; color:white; text-decoration:none; border:none; cursor:pointer; }
  </style>
</head>
<body>
  <h3>Download Job: {{ jobid }}</h3>
  <div id="log">Initializing...</div>
  <div style="margin-top:12px;">
    <a id="download_link" style="display:none;" class="btn" href="#">Download ZIP</a>
    <a href="/" class="btn" style="background:#6c757d;margin-left:8px;">Back to Tasks</a>
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
        }
        evtSource.close();
      } else if (payload.status === 'error') {
        evtSource.close();
      }
    }
  } catch (ex) { console.error(ex); }
};
evtSource.onerror = function(e) { evtSource.close(); };
</script>
</body>
</html>
"""

@app.route("/", methods=["GET"])
def index():
    load_bad_video_ids()
    try:
        tasks = get_video_task_list()
    except Exception as e:
        flash(f"Error fetching task-list: {e}", "error")
        tasks = []
    
    # Sort by ID desc
    try:
        tasks.sort(key=lambda x: int(x['id']), reverse=True)
    except:
        pass
        
    return render_template_string(TASKS_TEMPLATE, tasks=tasks)

@app.route("/start-job", methods=["POST"])
def start_job():
    selected = request.form.getlist("taskid")
    if not selected:
        return jsonify({"error": "No tasks selected."}), 400
    
    task_ids = [int(s) for s in selected if s.isdigit()]
    
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

if __name__ == "__main__":
    os.makedirs(SAVE_ROOT, exist_ok=True)
    load_bad_video_ids()
    print(f"Starting Video Download UI on http://127.0.0.1:5002") # Using port 5002 to avoid conflict with image saver
    app.run(debug=True, host="127.0.0.1", port=5002)
