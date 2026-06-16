#!/usr/bin/env python3
"""
save_images_ui.py

Flask UI wrapper with live status/progress for saving images into SAVE_ROOT
and zipping them for download.

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
import concurrent.futures
from typing import Tuple, Optional, Any, List
from flask import Flask, render_template_string, request, send_file, redirect, url_for, flash, Response, jsonify

# ---------------- CONFIG ----------------
API_BASE = "http://localhost/api"
POLL_INTERVAL_SECONDS = 8

PENDING_DIR = r"H:\PENDING_DIR"
PENDING_DIR = os.path.abspath(PENDING_DIR)
SAVE_ROOT = PENDING_DIR

REQUEST_TIMEOUT = 25
USER_AGENT = "SaveImagesByGroup/1.5"
MAX_RETRIES = 6
INITIAL_BACKOFF = 1.0
MAX_BACKOFF = 60.0
JITTER_FACTOR = 0.25
MAX_WORKERS = 8  # Parallel downloads
BAD_IMAGE_IDS_FILE = os.path.join(SAVE_ROOT, "bad_image_ids.json")
# ----------------------------------------

session = requests.Session()
# connection pool size
adapter = requests.adapters.HTTPAdapter(pool_connections=MAX_WORKERS, pool_maxsize=MAX_WORKERS)
session.mount('http://', adapter)
session.mount('https://', adapter)
session.headers.update({"User-Agent": USER_AGENT, "Accept": "application/json"})

bad_image_ids = set()
bad_image_lock = threading.Lock()

# ---------------- Job tracking ----------------
# job_status[jobid] = { "status": "running|done|error", "messages": [..], "zip_path": str|None, "error": str|None }
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

# ---------------- Helper functions (your logic) ----------------

def load_bad_image_ids():
    global bad_image_ids
    with bad_image_lock:
        try:
            if os.path.exists(BAD_IMAGE_IDS_FILE):
                with open(BAD_IMAGE_IDS_FILE, "r", encoding="utf-8") as f:
                    data = json.load(f)
                    if isinstance(data, list):
                        bad_image_ids = set(int(x) for x in data if isinstance(x, (int, str)) and str(x).isdigit())
                    elif isinstance(data, dict):
                        lst = data.get("ids") or data.get("bad_image_ids") or []
                        if isinstance(lst, list):
                            bad_image_ids = set(int(x) for x in lst if isinstance(x, (int, str)) and str(x).isdigit())
        except Exception as e:
            print(f"[WARN] Could not load bad_image_ids from {BAD_IMAGE_IDS_FILE}: {e}")
            bad_image_ids = set()

def save_bad_image_ids():
    with bad_image_lock:
        try:
            os.makedirs(SAVE_ROOT, exist_ok=True)
            with open(BAD_IMAGE_IDS_FILE, "w", encoding="utf-8") as f:
                json.dump(sorted(list(bad_image_ids)), f, indent=2)
        except Exception as e:
            print(f"[WARN] Could not save bad_image_ids to {BAD_IMAGE_IDS_FILE}: {e}")

def _compute_backoff(attempt: int) -> float:
    backoff = min(MAX_BACKOFF, INITIAL_BACKOFF * (2 ** (attempt - 1)))
    jitter = backoff * JITTER_FACTOR
    return max(0.0, backoff + random.uniform(-jitter, jitter))

def request_with_retries(method: str, url: str, retries: Optional[int] = None, **kwargs):
    last_exception = None
    max_attempts = retries if (isinstance(retries, int) and retries > 0) else MAX_RETRIES
    for attempt in range(1, max_attempts + 1):
        try:
            # Removed global throttle for parallelism
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
    url = f"{API_BASE}/task-list"
    resp = request_with_retries("get", url)
    return resp.json()

def get_subtask_list(taskid: int):
    url = f"{API_BASE}/subtask-list?taskid={taskid}"
    resp = request_with_retries("get", url)
    return resp.json()

def get_image_list(subtaskid: int):
    url = f"{API_BASE}/image-list?subtaskid={subtaskid}"
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

def fetch_image_base64_and_group(imageid: int) -> Tuple[str, Optional[str], Optional[str]]:
    with bad_image_lock:
        if imageid in bad_image_ids:
            raise ValueError(f"Image {imageid} is blacklisted (previously failed)")

    url = f"{API_BASE}/send-image?imageid={imageid}"
    last_exc = None
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            resp = request_with_retries("get", url, retries=1)
            payload = resp.json()
            item = _find_first_dict(payload)
            if not item:
                raise ValueError(f"Unexpected send-image response for {imageid}: {payload}")

            attachment_raw = item.get("attachment") if isinstance(item, dict) else None
            attachment = None
            if isinstance(attachment_raw, dict):
                attachment = attachment_raw
            else:
                attachment = _find_first_dict(attachment_raw) if attachment_raw is not None else {}

            if attachment is None:
                attachment = {}

            b64 = None
            name = None
            if isinstance(attachment, dict):
                b64 = attachment.get("data") or attachment.get("base64") or attachment.get("b64")
                name = attachment.get("name") or attachment.get("filename")
            if not b64 and isinstance(item, dict):
                b64 = item.get("data") or item.get("base64") or item.get("b64")
                if not name:
                    name = item.get("name") or item.get("filename")

            group = item.get("group") if isinstance(item, dict) else None

            if not b64:
                raise ValueError(f"No base64 data returned for imageid {imageid}: {payload}")

            return b64, name, group

        except Exception as e:
            last_exc = e
            if attempt >= MAX_RETRIES:
                print(f"    ERROR fetching image {imageid} (attempt {attempt}/{MAX_RETRIES}): {e}")
                with bad_image_lock:
                    try:
                        bad_image_ids.add(int(imageid))
                    except Exception:
                        pass
                save_bad_image_ids()
                raise
            else:
                backoff = _compute_backoff(attempt)
                print(f"    WARN: malformed send-image payload for {imageid} (attempt {attempt}/{MAX_RETRIES}): {e} — retrying in {backoff:.1f}s")
                time.sleep(backoff)
    raise last_exc or ValueError(f"Failed to fetch normalized payload for imageid {imageid}")

def update_image_status(imageid: int):
    url = f"{API_BASE}/update-image-status"
    payload = {"imageId": imageid}
    resp = request_with_retries("post", url, json=payload)
    try:
        return resp.json()
    except Exception:
        return resp.text

def save_image_to_path(binary_bytes: bytes, filename: str, out_dir: str) -> str:
    os.makedirs(out_dir, exist_ok=True)
    safe_name = re.sub(r'[\\/:"*?<>|]+', "_", (filename or "unnamed.jpg")).strip()
    if not safe_name:
        safe_name = "image.jpg"
    save_path = os.path.join(out_dir, safe_name)
    
    # Check if file already exists
    if os.path.exists(save_path):
        return save_path

    with open(save_path, "wb") as f:
        f.write(binary_bytes)
    return save_path

# ---------------- Worker Logic ----------------

def process_one_image(jobid: str, img: dict) -> Optional[str]:
    """
    Downloads and saves a single image. Returns the saved path if successful, None otherwise.
    """
    imageid = img.get("id")
    if not imageid:
        return None
    try:
        imageid_int = int(imageid)
    except Exception:
        imageid_int = None

    sent_flag = img.get("sent", 0)
    if sent_flag:
        # emit_job_message(jobid, f"Skipping image {imageid} (already sent)") # verbose
        return None
    
    with bad_image_lock:
        if imageid_int is not None and imageid_int in bad_image_ids:
            emit_job_message(jobid, f"Skipping image {imageid} (blacklisted)")
            return None

    # emit_job_message(jobid, f"Fetching image {imageid}")
    try:
        b64, filename, group_name = fetch_image_base64_and_group(imageid_int if imageid_int is not None else imageid)
    except Exception as e:
        emit_job_message(jobid, f"ERROR fetching image {imageid}: {e}")
        return None

    if not group_name:
        group_name = "unknown_group"
    folder = safe_folder_name(group_name)
    out_dir = os.path.join(SAVE_ROOT, folder)

    # decode base64
    if isinstance(b64, str) and b64.startswith("data:"):
        try:
            b64 = b64.split(",", 1)[1]
        except Exception:
            pass
    try:
        binary = base64.b64decode(b64)
    except Exception as e:
        emit_job_message(jobid, f"ERROR decoding base64 for image {imageid}: {e}")
        with bad_image_lock:
            if imageid_int is not None:
                bad_image_ids.add(imageid_int)
        save_bad_image_ids()
        return None

    if not filename:
        filename = f"image_{imageid}.jpg"

    try:
        saved_path = save_image_to_path(binary, filename, out_dir)
        emit_job_message(jobid, f"Saved image {imageid} -> {filename}")
    except Exception as e:
        emit_job_message(jobid, f"ERROR saving image {imageid}: {e}")
        return None

    # update status
    try:
        update_image_status(imageid_int if imageid_int is not None else imageid)
    except Exception as e:
        emit_job_message(jobid, f"ERROR updating status for image {imageid}: {e}")
    
    return saved_path

# ---------------- High-level processing for selected tasks (with job updates) ----------------

def process_selected_tasks_to_saveroot_job(task_ids: List[int], jobid: str) -> List[str]:
    """
    Background worker: saves images to SAVE_ROOT/<safe_group_name>/filename,
    updates job_status via emit_job_message, and returns list of saved file paths.
    """
    saved_files = []
    os.makedirs(SAVE_ROOT, exist_ok=True)
    emit_job_message(jobid, f"Starting processing {len(task_ids)} task(s): {task_ids}")

    with concurrent.futures.ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        for taskidx, taskid in enumerate(task_ids, start=1):
            emit_job_message(jobid, f"Fetching subtasks for task {taskid} ({taskidx}/{len(task_ids)})")
            try:
                subtasks = get_subtask_list(taskid)
            except Exception as e:
                emit_job_message(jobid, f"ERROR fetching subtask-list for task {taskid}: {e}")
                continue

            if not isinstance(subtasks, list) or not subtasks:
                emit_job_message(jobid, f"No subtasks for task {taskid}")
                continue

            # Collect all images for this task first
            all_images_for_task = []
            
            for sub in subtasks:
                sub_id = sub.get("id")
                if not sub_id:
                    continue
                try:
                    images = get_image_list(sub_id)
                except Exception as e:
                    emit_job_message(jobid, f"ERROR fetching image-list for subtask {sub_id}: {e}")
                    continue

                if isinstance(images, list) and images:
                    all_images_for_task.extend(images)

            if not all_images_for_task:
                 emit_job_message(jobid, f"No images found for task {taskid}")
                 continue
            
            emit_job_message(jobid, f"Task {taskid}: Processing {len(all_images_for_task)} images with {MAX_WORKERS} workers...")
            
            # Submit to executor
            future_to_img = {
                executor.submit(process_one_image, jobid, img): img 
                for img in all_images_for_task
            }
            
            for future in concurrent.futures.as_completed(future_to_img):
                try:
                    res = future.result()
                    if res:
                        saved_files.append(res)
                except Exception as exc:
                    emit_job_message(jobid, f"Worker exception: {exc}")

    emit_job_message(jobid, f"Finished fetching images. {len(saved_files)} file(s) saved.")
    
    # Create zip of saved_files (paths relative to SAVE_ROOT)
    if saved_files:
        zip_fname = f"images_tasks_{jobid}_{int(time.time())}.zip"
        zip_path = os.path.join(tempfile.gettempdir(), zip_fname)
        try:
            with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
                for f in saved_files:
                    try:
                        arcname = os.path.relpath(f, SAVE_ROOT)
                    except Exception:
                        arcname = os.path.basename(f)
                    zf.write(f, arcname)
            emit_job_message(jobid, f"ZIP created: {zip_path}")
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
  <title>Save Images UI</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .panel { display: flex; gap: 20px; align-items: flex-start; }
    .col { flex: 1; min-width: 240px; }
    .task-list { border: 1px solid #ddd; padding: 8px; border-radius:6px; max-height: 360px; overflow: auto; }
    .task { padding: 8px; border-bottom: 1px solid #f0f0f0; }
    .controls { margin-top: 12px; }
    .btn { padding: 8px 12px; border-radius: 4px; background: #007bff; color: white; text-decoration:none; display:inline-block; border: none; cursor: pointer; }
    .btn:disabled { background: #aaa; cursor: not-allowed; }
    select[multiple] { width: 100%; height: 360px; border-radius:6px; padding:6px; }
    .small { font-size: 0.9em; color: #555; }
  </style>
</head>
<body>
  <h2>Tasks with pending &gt; 0</h2>
  {% if not tasks %}
    <p>No pending tasks found.</p>
  {% else %}
    <form id="start_form" method="post" action="{{ url_for('start_job') }}">
      <div class="panel">
        <div class="col">
          <div>
            <label><input type="checkbox" id="select_all" onchange="toggleAll(this)"> <strong>Select / Deselect All</strong></label>
            <div class="small">(This will toggle both the checkboxes and multi-select)</div>
          </div>
          <div style="margin-top:12px;" class="task-list" id="checkbox_container" aria-label="Task checkbox list">
            {% for t in tasks %}
              <div class="task">
                <label>
                  <input type="checkbox" name="taskid" value="{{ t['id'] }}" id="chk_{{ loop.index0 }}">
                  <strong>{% if t.get('taskname') %}{{ t.get('taskname') }}{% else %}Task {{ t.get('id') }}{% endif %}</strong> — pending: {{ t.get('pending') }} — ID: {{ t.get('id') }}
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

  const sel = document.getElementById('task_select');
  if (!sel) return;
  for (let i = 0; i < sel.options.length; i++) sel.options[i].selected = chk.checked;
}

document.addEventListener('DOMContentLoaded', function() {
  const sel = document.getElementById('task_select');
  if (!sel) return;
  sel.addEventListener('change', function() {
    const selectedValues = new Set(Array.from(sel.selectedOptions).map(o => o.value));
    const boxes = document.querySelectorAll('input[name="taskid"][type="checkbox"]');
    boxes.forEach(b => b.checked = selectedValues.has(b.value));
    document.getElementById('select_all').checked = Array.from(boxes).every(b => b.checked);
  });

  const boxes = document.querySelectorAll('input[name="taskid"][type="checkbox"]');
  boxes.forEach((b) => {
    b.addEventListener('change', function() {
      const opt = Array.from(sel.options).find(o => o.value === b.value);
      if (opt) opt.selected = b.checked;
      document.getElementById('select_all').checked = Array.from(boxes).every(x => x.checked);
    });
  });
});

// Intercept form submission to POST and then redirect to status page
document.getElementById('start_form')?.addEventListener('submit', function(e) {
  e.preventDefault();
  const form = e.target;
  const data = new FormData(form);
  // send fetch
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
  const sel = document.getElementById('task_select');
  if (sel) for (let i = 0; i < sel.options.length; i++) sel.options[i].selected = false;
  const sa = document.getElementById('select_all');
  if (sa) sa.checked = false;
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
    .done { background: #28a745; }
    .error { background: #dc3545; }
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
  // data is a JSON string for structured messages, or raw text
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
          // no zip produced
          downloadLink.style.display = "none";
          logEl.textContent += "No ZIP was produced for this job.\\n";
        }
        evtSource.close();
      } else if (payload.status === 'error') {
        downloadLink.style.display = "none";
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

app = Flask(__name__)
app.secret_key = "change_this_to_something_secret_in_prod"

# --------------------------------------------------------------------------
# Routes
# --------------------------------------------------------------------------

@app.route("/", methods=["GET"])
def index():
    load_bad_image_ids()
    try:
        tasks_resp = get_task_list()
    except Exception as e:
        flash(f"Error fetching task-list: {e}", "error")
        tasks_resp = []

    pending_tasks = []
    if isinstance(tasks_resp, list):
        pending_tasks = tasks_resp
    elif isinstance(tasks_resp, dict):
        if "data" in tasks_resp and isinstance(tasks_resp["data"], list):
            pending_tasks = tasks_resp["data"]
        elif "tasks" in tasks_resp and isinstance(tasks_resp["tasks"], list):
            pending_tasks = tasks_resp["tasks"]
        else:
            pending_tasks = [tasks_resp]

    to_show = []
    for t in pending_tasks:
        try:
            pending_count = int(t.get("pending", 0))
        except Exception:
            pending_count = 0
        if pending_count > 0:
            tid = t.get("id") or t.get("taskid") or t.get("taskId")
            if not tid:
                continue
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
            try:
                task_ids.append(int(float(s)))
            except Exception:
                pass
    if not task_ids:
        return jsonify({"error": "No valid task ids selected."}), 400

    # create job id and initial status
    jobid = uuid.uuid4().hex
    with job_status_lock:
        job_status[jobid] = {"status": "running", "messages": [], "zip_path": None, "error": None}

    # start background thread
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
        # Keep streaming until job is done or error
        while True:
            snapshot = get_job_snapshot(jobid)
            msgs = snapshot.get("messages", [])
            # send any new messages
            while last_index < len(msgs):
                m = msgs[last_index]
                data = json.dumps({"type": "message", "text": m})
                yield f"data: {data}\n\n"
                last_index += 1
            # send status updates occasionally
            status = snapshot.get("status")
            if status in ("done", "error"):
                payload = {"type": "status", "status": status, "jobid": jobid, "zip_path": snapshot.get("zip_path")}
                yield f"data: {json.dumps(payload)}\n\n"
                break
            # heartbeat/no-op to keep connection alive
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
    # stream file
    return send_file(zip_path, as_attachment=True, download_name=os.path.basename(zip_path))

# --------------------------------------------------------------------------
# Cleanup helper (same as before)
# --------------------------------------------------------------------------
def cleanup_old_zips(tempdir: str, pattern_prefix: str, max_age_seconds: int = 3600*2):
    now = time.time()
    for name in os.listdir(tempdir):
        if not name.startswith(pattern_prefix) or not name.endswith(".zip"):
            continue
        path = os.path.join(tempdir, name)
        try:
            mtime = os.path.getmtime(path)
            if now - mtime > max_age_seconds:
                os.remove(path)
        except Exception:
            pass

# --------------------------------------------------------------------------
# Start app
# --------------------------------------------------------------------------
if __name__ == "__main__":
    os.makedirs(SAVE_ROOT, exist_ok=True)
    load_bad_image_ids()
    print("Starting Flask UI on http://127.0.0.1:5001")
    app.run(debug=True, host="127.0.0.1", port=5001)
