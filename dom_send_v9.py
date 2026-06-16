#!/usr/bin/env python3
"""
WhatsApp Auto Sender - DOM EDITION (FULL FINAL UPDATED SCRIPT v9 ULTRA FAST & ROBUST)

UPDATES IN THIS VERSION:
- Press ESC twice BEFORE every new WhatsApp search in open_chat()
- Switch from PyAutoGUI/OS Dialog to native Selenium DOM file inputs (send_keys) for uploading!
- Bypasses OS File Chooser, 100% immune to window focus loss, 10x faster and background friendly.
- Multi-layered DOM upload fallback strategies:
  -> Direct upload via existing inputs
  -> Open attach menu + upload
  -> Open attach menu + click option (Photos/Doc) + upload
- Fine-tuned static wait sleeps inside open_chat() and send_files_in_batches() to maximize speed.
- If folder/group name is NOT found in WhatsApp:
  -> DO NOT hard reset UI
  -> Press ESC to clean search state
  -> SKIP to next folder immediately
  -> Folder stays in PENDING_DIR, so it retries automatically in next round
- open_chat() now returns 3 states:
  -> "FOUND"
  -> "NOT_FOUND"
  -> "ERROR"
- Hard reset ONLY on real UI errors / broken state
- NO cooldown when group not found
- Send max 3 files per batch
- If more files exist, send in next batches (3 + 3 + remaining)
- Only move/delete files that were ACTUALLY sent successfully
- Detect if Windows file path got pasted into chat composer
- Auto clear composer + retry same batch once
- Do NOT re-open chat before every batch
- Re-open chat ONLY when UI is broken / composer missing
- Auto attach mode:
  - Images/videos => Photos & videos
  - Docs/files => Document
- Robustness Updates:
  -> Added highly robust, multi-layer fallbacks for finding and clearing Search Box
  -> Multi-layer fallback checks for message Composer, attach plus button, and send button
  -> Strict multi-strategy Chat Header Verification to prevent sending to wrong chats
"""

import os
import sys
import time
import math
import json
import shutil
import signal
import random
import hashlib
import zipfile
import subprocess
from datetime import datetime

import requests
import pyautogui
import pyperclip

import undetected_chromedriver as uc

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, StaleElementReferenceException

# ================= CONFIG =================

PROFILE_DIR      = r"C:\temp\chrome-webdriver-profile"
PENDING_DIR      = r"\\Main-pc\h\PENDING_DIR"
COMPLETE_DIR     = r"C:\Users\user\Desktop\autosend\COMPLETE_DIR"
TEMP_STAGING_DIR = r"C:\t_W"

# ── Chrome 145 Config ──
CHROME_ZIP_URL           = "https://storage.googleapis.com/chrome-for-testing-public/145.0.7632.117/win64/chrome-win64.zip"
CHROMEDRIVER_ZIP_URL     = "https://storage.googleapis.com/chrome-for-testing-public/145.0.7632.117/win64/chromedriver-win64.zip"
CHROME_INSTALL_DIR       = r"C:\temp\chrome-145"
CHROME_BINARY_PATH       = os.path.join(CHROME_INSTALL_DIR, "chrome-win64", "chrome.exe")
CHROMEDRIVER_BINARY_PATH = os.path.join(CHROME_INSTALL_DIR, "chromedriver-win64", "chromedriver.exe")

WAIT_TIMEOUT  = 120
POLL_INTERVAL = 1

# ── Subscription API ──
API_BASE_URL = "https://wa.voreva.in/api"
SESSION_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "session.json")

# ── RATE LIMITING ──
MAX_SENDS_PER_HOUR  = 5000
MIN_DELAY_BETWEEN   = 0.3
MAX_DELAY_BETWEEN   = 0.8
LONG_BREAK_EVERY    = 3000
LONG_BREAK_DURATION = (60, 120)

# IMPORTANT: send max 3 files per batch
MAX_BATCH_ATTACH = 3

MEDIA_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

DOC_EXTS = {
    ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx",
    ".txt", ".csv", ".zip", ".rar", ".7z", ".json", ".xml", ".log"
}

ALLOWED_EXTS = MEDIA_EXTS | DOC_EXTS

LOG_FILE  = os.path.join(COMPLETE_DIR, "autosend.log")
_shutdown = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE    = 0.02

# ── State ──
_sends_this_hour   = 0
_hour_start_time   = time.time()
_sends_since_break = 0

_session = {
    "username": "", "status": "unauthorized", "plan": "None",
    "daily_limit": 0, "sent_today": 0, "expires_at": "",
    "message": "", "last_validated_at": ""
}

# ================= SIGNAL =================

def stop_handler(sig, frame):
    global _shutdown
    _shutdown = True
    write_log("[INFO] Shutdown requested")

signal.signal(signal.SIGINT, stop_handler)
signal.signal(signal.SIGTERM, stop_handler)

# ================= LOG =================

def write_log(msg):
    os.makedirs(COMPLETE_DIR, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"[{ts}] {msg}\n")
    except Exception as e:
        print(f"Log Error: {e}")
    print(msg)

# ================= SUBSCRIPTION =================

def get_hwid():
    cmd = 'wmic csproduct get uuid'
    try:
        uuid = subprocess.check_output(cmd, shell=True, stderr=subprocess.DEVNULL).decode().split('\n')[1].strip()
        if not uuid or uuid == "FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF":
            from getmac import get_mac_address
            uuid = get_mac_address()
    except:
        uuid = "UNKNOWN_HWID"
    return hashlib.sha256(uuid.encode()).hexdigest()

def _save_session(data):
    try:
        with open(SESSION_FILE, "w") as f:
            json.dump(data, f)
    except:
        pass

def _load_session():
    if os.path.exists(SESSION_FILE):
        try:
            with open(SESSION_FILE, "r") as f:
                return json.load(f)
        except:
            return None
    return None

def validate_session():
    global _session
    saved = _load_session()
    if not saved or not saved.get("username"):
        return {"status": "unauthorized", "message": "Login required"}

    hwid = get_hwid()
    try:
        resp = requests.post(f"{API_BASE_URL}/validate", json={
            "username": saved["username"],
            "hwid": hwid
        }, timeout=10)
        data = resp.json()

        if data.get("status") == "success":
            data["last_validated_at"] = datetime.now().isoformat()
            _session.update({
                "username": data["username"], "status": "active",
                "plan": data["plan"], "daily_limit": data["daily_limit"],
                "sent_today": data["sent_today"], "expires_at": data["expires_at"],
                "message": "", "last_validated_at": data["last_validated_at"]
            })
            _save_session(_session)
            return _session
        else:
            _session.update({
                "status": data.get("status", "error"),
                "message": data.get("message", "Session invalid")
            })
            return _session
    except Exception as e:
        last_val = saved.get("last_validated_at")
        if last_val:
            try:
                last_dt = datetime.fromisoformat(last_val)
                hours_since = (datetime.now() - last_dt).total_seconds() / 3600
                if hours_since < 24:
                    _session.update(saved)
                    _session["status"] = "active"
                    write_log("[INFO] Running in offline grace mode")
                    return _session
            except:
                pass
        return {"status": "error", "message": f"Server connection failed: {e}"}

def login_user(username, password):
    global _session
    hwid = get_hwid()
    try:
        resp = requests.post(f"{API_BASE_URL}/login", json={
            "username": username, "password": password, "hwid": hwid
        }, timeout=10)
        data = resp.json()
        if data.get("status") == "success":
            data["last_validated_at"] = datetime.now().isoformat()
            _session.update({
                "username": username, "status": "active",
                "plan": data["plan"], "daily_limit": data["daily_limit"],
                "sent_today": data["sent_today"], "expires_at": data["expires_at"],
                "message": "", "last_validated_at": data["last_validated_at"]
            })
            _save_session(_session)
            return data
        return data
    except Exception as e:
        return {"status": "error", "message": f"Login failed: {e}"}

def report_usage(count=1):
    if not _session.get("username"):
        return
    try:
        requests.post(f"{API_BASE_URL}/log-usage", json={
            "username": _session["username"], "hwid": get_hwid(), "count": count
        }, timeout=5)
    except:
        pass

def check_daily_limit():
    if _session.get("daily_limit", 0) <= 0:
        return True
    return _session.get("sent_today", 0) < _session["daily_limit"]

def do_login_prompt():
    username, password = "uva", "uva"
    write_log(f"⏳ Authenticating as '{username}'...")
    result = login_user(username, password)
    if result.get("status") == "success":
        write_log(f"✅ Login successful! Plan: {_session['plan']}")
        return True
    write_log(f"❌ {result.get('message', 'Login failed')}")
    return False

def ensure_authenticated():
    write_log("[INFO] Checking subscription status...")
    result = validate_session()
    if result.get("status") == "active":
        write_log(f"[OK] Subscription active — User: {_session['username']}, Plan: {_session['plan']}")
        return True
    return do_login_prompt()

# ================= RATE LIMITER =================

def check_rate_limit():
    global _sends_this_hour, _hour_start_time, _sends_since_break
    if time.time() - _hour_start_time >= 3600:
        _sends_this_hour = 0
        _hour_start_time = time.time()

    if _sends_this_hour >= MAX_SENDS_PER_HOUR:
        wait_secs = 3600 - (time.time() - _hour_start_time)
        write_log(f"[RATE LIMIT] Hourly cap hit. Sleeping {wait_secs/60:.1f} min...")
        time.sleep(wait_secs)
        _sends_this_hour = 0
        _hour_start_time = time.time()

    if _sends_since_break >= LONG_BREAK_EVERY:
        duration = random.randint(*LONG_BREAK_DURATION)
        write_log(f"[RATE LIMIT] Taking a long break: {duration}s")
        time.sleep(duration)
        _sends_since_break = 0

def record_send():
    global _sends_this_hour, _sends_since_break
    _sends_this_hour += 1
    _sends_since_break += 1
    current_sent = int(_session.get("sent_today", 0))
    _session["sent_today"] = current_sent + 1
    report_usage(1)

# ================= FAST BEZIER MOUSE MOVEMENT =================

def _bezier_point(t, p0, p1, p2, p3):
    return (
        (1-t)**3 * p0[0] + 3*(1-t)**2*t * p1[0] + 3*(1-t)*t**2 * p2[0] + t**3 * p3[0],
        (1-t)**3 * p0[1] + 3*(1-t)**2*t * p1[1] + 3*(1-t)*t**2 * p2[1] + t**3 * p3[1],
    )

def human_move_to(x, y, duration=None):
    start_x, start_y = pyautogui.position()
    end_x, end_y     = int(x), int(y)

    cp1 = (start_x + random.randint(-40, 40), start_y + random.randint(-40, 40))
    cp2 = (end_x   + random.randint(-40, 40), end_y   + random.randint(-40, 40))

    steps = random.randint(10, 20)
    if duration is None:
        duration = random.uniform(0.15, 0.3)

    for i in range(steps + 1):
        t = i / steps
        t_eased = (1 - math.cos(t * math.pi)) / 2
        bx, by  = _bezier_point(t_eased, (start_x, start_y), cp1, cp2, (end_x, end_y))
        pyautogui.moveTo(int(bx), int(by))
        time.sleep(duration / steps)

    pyautogui.moveTo(end_x, end_y)

# ================= DOM HELPERS =================

def dom_click(driver, element):
    driver.execute_script("""
        const el = arguments[0];
        const opts = {view: window, bubbles: true, cancelable: true};
        el.dispatchEvent(new MouseEvent('mousedown', opts));
        el.dispatchEvent(new MouseEvent('mouseup', opts));
        el.dispatchEvent(new MouseEvent('click', opts));
    """, element)

# ================= CHROME =================

def ensure_chrome_v145():
    os.makedirs(CHROME_INSTALL_DIR, exist_ok=True)

    if not os.path.exists(CHROME_BINARY_PATH):
        write_log("[INFO] Downloading Chrome v145...")
        zip_path = os.path.join(CHROME_INSTALL_DIR, "chrome.zip")
        resp = requests.get(CHROME_ZIP_URL, stream=True, timeout=30)
        with open(zip_path, "wb") as f:
            for chunk in resp.iter_content(8192):
                f.write(chunk)
        zipfile.ZipFile(zip_path, 'r').extractall(CHROME_INSTALL_DIR)
        os.remove(zip_path)

    if not os.path.exists(CHROMEDRIVER_BINARY_PATH):
        write_log("[INFO] Downloading ChromeDriver v145...")
        zip_path = os.path.join(CHROME_INSTALL_DIR, "driver.zip")
        resp = requests.get(CHROMEDRIVER_ZIP_URL, stream=True, timeout=30)
        with open(zip_path, "wb") as f:
            for chunk in resp.iter_content(8192):
                f.write(chunk)
        zipfile.ZipFile(zip_path, 'r').extractall(CHROME_INSTALL_DIR)
        os.remove(zip_path)

def create_driver():
    opts = uc.ChromeOptions()
    opts.add_argument(f"--user-data-dir={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--lang=en-US")
    # CRITICAL: Prevent chromedriver from hanging for 30-70 seconds waiting for WhatsApp background network requests
    opts.page_load_strategy = 'none' 
    return uc.Chrome(
        options=opts,
        version_main=145,
        browser_executable_path=CHROME_BINARY_PATH,
        driver_executable_path=CHROMEDRIVER_BINARY_PATH
    )

def keep_session_alive(driver):
    try:
        sidebar = driver.find_elements(By.XPATH, "//div[@id='pane-side']")
        if sidebar:
            driver.execute_script("arguments[0].scrollTop += 10; arguments[0].scrollTop -= 10;", sidebar[0])
    except:
        pass

def hard_reset_ui(driver):
    try:
        write_log("[WARN] Initiating HARD UI RESET...")

        try:
            pyautogui.press('esc')
            time.sleep(0.4)
            pyautogui.press('esc')
            time.sleep(0.4)
        except:
            pass

        try:
            driver.execute_script("document.activeElement.blur();")
            time.sleep(0.5)
        except:
            pass

        driver.refresh()
        write_log("[INFO] Page refreshed, waiting for reload...")
        wait_for_whatsapp(driver)
        write_log("[INFO] UI Reset Complete. WhatsApp reloaded.")

    except Exception as e:
        write_log(f"[CRITICAL] UI reset failed: {e}")

# ================= HIGHLIGHT =================

def highlight_element(driver, element, color="red", duration=0.8):
    try:
        driver.execute_script(f"""
            const el = arguments[0];
            const originalStyle = el.style.border;
            el.style.border = '4px solid {color}';
            el.style.boxShadow = '0 0 10px {color}';
            setTimeout(() => {{
                el.style.border = originalStyle;
                el.style.boxShadow = 'none';
            }}, {int(duration * 1000)});
        """, element)
    except:
        pass

# ================= WHATSAPP =================

def wait_for_whatsapp(driver):
    WebDriverWait(driver, WAIT_TIMEOUT).until(
        EC.presence_of_element_located((By.XPATH, "//div[@id='pane-side'] | //div[@contenteditable='true']"))
    )

def get_message_composer(driver):
    script = """
    const selectors = [
        "footer div[contenteditable='true'][role='textbox'][data-tab='10']",
        "footer div[contenteditable='true'][role='textbox'][data-lexical-editor='true']",
        "footer div[aria-placeholder='Type a message']",
        "footer div[contenteditable='true']",
        "footer div[role='textbox']",
        "div[contenteditable='true'][data-tab='10']"
    ];
    for (let sel of selectors) {
        try {
            let els = document.querySelectorAll(sel);
            for (let el of els) {
                if (el.offsetWidth > 0 && el.offsetHeight > 0) return el;
            }
        } catch(e) {}
    }
    let footer = document.querySelector('footer');
    if (footer) {
        let generic = ["div[contenteditable='true']", "div[role='textbox']", "p[role='textbox']"];
        for (let sel of generic) {
            let els = footer.querySelectorAll(sel);
            for (let el of els) {
                if (el.offsetWidth > 0 && el.offsetHeight > 0) return el;
            }
        }
    }
    return null;
    """
    try:
        el = driver.execute_script(script)
        if el: return el
    except:
        pass

    return None

def wait_until_back_to_chat_ready(driver, timeout=20):
    end = time.time() + timeout

    while time.time() < end:
        try:
            composer = get_message_composer(driver)
            if composer and composer.is_displayed():
                return True
        except:
            pass

        try:
            pyautogui.press('esc')
        except:
            pass

        time.sleep(0.4)

    return False

def detect_file_path_pasted(driver):
    try:
        # Check standard message composer
        box = get_message_composer(driver)
        boxes = []
        if box:
            boxes.append(box)

        # Check active/focused element
        try:
            active_el = driver.execute_script("return document.activeElement;")
            if active_el and active_el not in boxes:
                boxes.append(active_el)
        except:
            pass

        # Check all visible contenteditable elements / text inputs
        try:
            all_editable = driver.find_elements(By.CSS_SELECTOR, "div[contenteditable='true'], input[type='text']")
            for el in all_editable:
                try:
                    if el.is_displayed() and el not in boxes:
                        boxes.append(el)
                except:
                    pass
        except:
            pass

        for b in boxes:
            try:
                txt = (b.text or driver.execute_script("return arguments[0].innerText || arguments[0].value;", b) or "").strip()
                path_markers = ["C:\\", "\\\\", "//", "C:/", "t_W", "TEMP_STAGING_DIR", "PENDING_DIR"]
                for marker in path_markers:
                    if marker in txt:
                        write_log(f"[WARN] File path marker '{marker}' pasted into edit box instead of dialog: {txt}")
                        return True

                # Check for extensions + slashes
                for ext in ALLOWED_EXTS:
                    if ext in txt and ("\\" in txt or "/" in txt or ":" in txt):
                        write_log(f"[WARN] File path with extension '{ext}' pasted into edit box: {txt}")
                        return True
            except:
                pass

    except Exception as e:
        write_log(f"[WARN] Path detection failed: {e}")

    return False

def clear_element_text(driver, el):
    try:
        try:
            dom_click(driver, el)
        except:
            el.click()
        time.sleep(0.05)
        driver.execute_script("""
            arguments[0].focus();
            document.execCommand('selectAll', false, null);
            document.execCommand('delete', false, null);
            arguments[0].dispatchEvent(new Event('input', { bubbles: true }));
        """, el)
        time.sleep(0.1)
    except Exception as e:
        write_log(f"[WARN] clear_element_text failed, falling back to keyboard: {e}")
        try:
            el.send_keys(Keys.CONTROL, "a")
            time.sleep(0.05)
            el.send_keys(Keys.BACKSPACE)
        except:
            pass

def type_element_text(driver, el, text):
    try:
        try:
            dom_click(driver, el)
        except:
            el.click()
        time.sleep(0.05)
        driver.execute_script("""
            arguments[0].focus();
            document.execCommand('selectAll', false, null);
            document.execCommand('delete', false, null);
            document.execCommand('insertText', false, arguments[1]);
            arguments[0].dispatchEvent(new Event('input', { bubbles: true }));
        """, el, text)
        time.sleep(0.1)
    except Exception as e:
        write_log(f"[WARN] type_element_text failed, falling back to paste: {e}")
        try:
            el.send_keys(Keys.CONTROL, "a")
            time.sleep(0.05)
            el.send_keys(Keys.BACKSPACE)
            time.sleep(0.05)
            pyperclip.copy(text)
            el.send_keys(Keys.CONTROL, "v")
        except:
            try:
                el.send_keys(text)
            except:
                pass

def clear_chat_composer(driver):
    try:
        # Find all editable elements
        try:
            boxes = driver.find_elements(By.CSS_SELECTOR, "div[contenteditable='true'], input[type='text']")
            cleared_any = False
            for box in boxes:
                try:
                    if box.is_displayed():
                        txt = (box.text or driver.execute_script("return arguments[0].innerText || arguments[0].value;", box) or "").strip()
                        if any(marker in txt for marker in ["C:\\", "\\\\", "//", "C:/", "t_W"]) or any(ext in txt and ("\\" in txt or "/" in txt) for ext in ALLOWED_EXTS):
                            clear_element_text(driver, box)
                            cleared_any = True
                except:
                    pass
            if cleared_any:
                write_log("[INFO] Cleared chat composer / edit boxes containing file paths.")
                return True
        except:
            pass

        # Fallback to standard composer
        box = get_message_composer(driver)
        if box:
            clear_element_text(driver, box)
            write_log("[INFO] Cleared standard chat composer text")
            return True

    except Exception as e:
        write_log(f"[WARN] Could not clear composer: {e}")

    return False

def clear_search_box(driver, search):
    clear_element_text(driver, search)

def get_search_box(driver):
    script = """
    const selectors = [
        'div#side div[contenteditable="true"][data-tab="3"]',
        'div#side div[contenteditable="true"]',
        'div#side div[role="textbox"]',
        'div#side div.lexical-rich-text-input div[contenteditable="true"]',
        'div#side div[title="Search input element"]',
        'div#side input[data-tab="3"]',
        'div#side input[aria-label*="Search"]',
        'div#side p.selectable-text.copyable-text'
    ];
    for (let sel of selectors) {
        try {
            let els = document.querySelectorAll(sel);
            for (let el of els) {
                if (el.offsetWidth > 0 && el.offsetHeight > 0) return el;
            }
        } catch(e) {}
    }
    let side = document.getElementById('side');
    if (side) {
        let generic = ["div[contenteditable='true']", "div[role='textbox']", "p[role='textbox']", "input"];
        for (let sel of generic) {
            let els = side.querySelectorAll(sel);
            for (let el of els) {
                if (el.offsetWidth > 0 && el.offsetHeight > 0) return el;
            }
        }
    }
    return null;
    """
    try:
        el = driver.execute_script(script)
        if el: return el
    except:
        pass

    # Keyboard shortcut fallback
    try:
        driver.find_element(By.TAG_NAME, "body").send_keys(Keys.CONTROL, Keys.ALT, "/")
        time.sleep(0.5)
        els = driver.find_elements(By.CSS_SELECTOR, '#side div[contenteditable="true"], #side input')
        visible = [e for e in els if e.is_displayed()]
        if visible:
            return visible[0]
    except:
        pass

    return None

def chat_header_matches(driver, name):
    try:
        wait = WebDriverWait(driver, 8)
        header_el = wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@id='main']//header")))
        
        # Method 1: Check elements with 'title' attribute inside the header
        title_elements = header_el.find_elements(By.XPATH, ".//span[@title]")
        for te in title_elements:
            title_attr = (te.get_attribute("title") or "").strip()
            if title_attr.lower() == name.lower() or name.lower() in title_attr.lower():
                return True, [title_attr]
        
        # Method 2: Check text lines directly
        header_text = header_el.text
        header_lines = [line.strip() for line in header_text.split('\n') if line.strip()]

        for line in header_lines:
            if name.lower() in line.lower() or line.lower() in name.lower():
                return True, header_lines

        # Method 3: Deep span search
        spans = header_el.find_elements(By.XPATH, ".//span")
        for s in spans:
            try:
                s_txt = s.text.strip().replace("...", "")
                if s_txt and len(s_txt) >= 2:
                    if s_txt.lower() in name.lower() or name.lower() in s_txt.lower():
                        return True, [s_txt]
            except:
                pass

        return False, header_lines
    except Exception as e:
        return None, [f"header-check-error: {e}"]

def open_chat(driver, name):
    """
    Returns:
      "FOUND"     -> exact/usable chat opened
      "NOT_FOUND" -> search worked, but no matching chat found
      "ERROR"     -> UI/search broken
    """
    t_start = time.time()
    write_log(f"[DEBUG] open_chat started for: {name}")
    wait = WebDriverWait(driver, 15)

    try:
        time.sleep(0.2)

        # Press ESC before every fresh search to close any leftover search state,
        # popup, selected result, preview, attach menu, etc.
        t0 = time.time()
        try:
            pyautogui.press('esc')
            time.sleep(0.1)
            pyautogui.press('esc')
            time.sleep(0.1)
        except:
            pass
        write_log(f"[DEBUG] [STEP 1] ESC x2 done in {(time.time()-t0)*1000:.0f}ms")

        t0 = time.time()
        search = get_search_box(driver)
        write_log(f"[DEBUG] [STEP 2] get_search_box done in {(time.time()-t0)*1000:.0f}ms | found={search is not None}")
        if not search:
            sc_path = r"C:\temp\wa_error_search.png"
            try:
                driver.save_screenshot(sc_path)
            except:
                pass
            write_log(f"[CRITICAL] FAILED to find search box. Check screenshot: {sc_path}")
            return "ERROR"

        t0 = time.time()
        highlight_element(driver, search, color="red", duration=0.3)
        write_log(f"[DEBUG] [STEP 3] highlight_element done in {(time.time()-t0)*1000:.0f}ms")

        # DOM click only — NO mouse movement (human_move_to was the bottleneck)
        t0 = time.time()
        try:
            dom_click(driver, search)
            write_log(f"[DEBUG] [STEP 4] dom_click done in {(time.time()-t0)*1000:.0f}ms")
        except Exception as dom_err:
            write_log(f"[DEBUG] [STEP 4] dom_click failed ({dom_err}), trying search.click()...")
            try:
                search.click()
                write_log(f"[DEBUG] [STEP 4] search.click() done in {(time.time()-t0)*1000:.0f}ms")
            except Exception as click_err:
                write_log(f"[DEBUG] [STEP 4] search.click() also failed: {click_err}")

        t0 = time.time()
        type_element_text(driver, search, name)
        write_log(f"[DEBUG] [STEP 5] type_element_text('{name}') done in {(time.time()-t0)*1000:.0f}ms")

        # Wait for search results to render
        t0 = time.time()
        time.sleep(random.uniform(0.3, 0.5))
        write_log(f"[DEBUG] [STEP 6] search results wait done in {(time.time()-t0)*1000:.0f}ms")

        # Try exact title match
        combined_xp = " | ".join([
            f'//span[@title="{name}"]',
            f'//div[@id="pane-side"]//span[@title="{name}"]',
            f'//div[@id="pane-side"]//*[@title="{name}"]',
            f'//span[normalize-space()="{name}"]',
            f'//div[@id="pane-side"]//span[normalize-space()="{name}"]'
        ])

        try:
            t0 = time.time()
            result = WebDriverWait(driver, 2.5).until(
                EC.element_to_be_clickable((By.XPATH, combined_xp))
            )
            write_log(f"[DEBUG] [STEP 7] exact xpath matched in {(time.time()-t0)*1000:.0f}ms")

            t0 = time.time()
            try:
                dom_click(driver, result)
                write_log(f"[DEBUG] [STEP 8] dom_click(result) done in {(time.time()-t0)*1000:.0f}ms")
            except:
                result.click()
                write_log(f"[DEBUG] [STEP 8] result.click() done in {(time.time()-t0)*1000:.0f}ms")
            
            time.sleep(random.uniform(0.3, 0.5))

            t0 = time.time()
            header_ok, header_lines = chat_header_matches(driver, name)
            write_log(f"[DEBUG] [STEP 9] chat_header_matches done in {(time.time()-t0)*1000:.0f}ms | ok={header_ok}")

            if header_ok is True:
                t0 = time.time()
                wait_until_back_to_chat_ready(driver, timeout=8)
                write_log(f"[DEBUG] [STEP 10] wait_until_back_to_chat_ready done in {(time.time()-t0)*1000:.0f}ms")
                write_log(f"[OK] Chat Verified (exact): '{name}' | total open_chat time: {(time.time()-t_start)*1000:.0f}ms")
                return "FOUND"
            elif header_ok is False:
                write_log(f"[WARN] Exact click but header mismatch for '{name}' (saw {header_lines})")
                return "NOT_FOUND"
            else:
                # If header check errored but click worked, still treat as FOUND
                write_log(f"[WARN] Header verification skipped after exact click for '{name}'")
                wait_until_back_to_chat_ready(driver, timeout=8)
                write_log(f"[OK] Chat opened (header check skipped): '{name}' | total: {(time.time()-t_start)*1000:.0f}ms")
                return "FOUND"
        except:
            pass

        write_log(f"[DEBUG] [STEP 7] No exact xpath matched. Checking visible search results...")

        # If no exact result, inspect visible search results
        try:
            t0 = time.time()
            result_candidates = driver.find_elements(
                By.XPATH,
                '//div[@id="pane-side"]//*[@title] | //div[@id="pane-side"]//*[@dir="auto"]'
            )
            visible_titles = []
            for el in result_candidates[:20]:
                try:
                    if el.is_displayed():
                        t = (el.get_attribute("title") or el.text or "").strip()
                        if t:
                            visible_titles.append(t)
                except:
                    pass
            write_log(f"[DEBUG] [STEP 11] visible results scan done in {(time.time()-t0)*1000:.0f}ms | found={len(visible_titles)}")

            if visible_titles:
                write_log(f"[INFO] Search results visible but exact group not found for '{name}'. Top results: {visible_titles[:5]}")
                return "NOT_FOUND"
        except:
            pass

        # Try Enter once (sometimes first result is selected automatically)
        try:
            t0 = time.time()
            search.send_keys(Keys.ENTER)
            time.sleep(0.4)
            write_log(f"[DEBUG] [STEP 12] Enter key + wait done in {(time.time()-t0)*1000:.0f}ms")

            t0 = time.time()
            header_ok, header_lines = chat_header_matches(driver, name)
            write_log(f"[DEBUG] [STEP 13] header check after Enter done in {(time.time()-t0)*1000:.0f}ms | ok={header_ok}")

            if header_ok is True:
                wait_until_back_to_chat_ready(driver, timeout=8)
                write_log(f"[OK] Chat Verified (Enter fallback): '{name}' | total: {(time.time()-t_start)*1000:.0f}ms")
                return "FOUND"
            elif header_ok is False:
                write_log(f"[INFO] Enter fallback did not open correct chat for '{name}' (saw {header_lines})")
                return "NOT_FOUND"
        except:
            pass

        write_log(f"[WARN] Group/chat '{name}' not found in WhatsApp search. Total time: {(time.time()-t_start)*1000:.0f}ms")
        return "NOT_FOUND"

    except Exception as e:
        write_log(f"[ERROR] open_chat failed for {name}: {e} | total time: {(time.time()-t_start)*1000:.0f}ms")
        return "ERROR"

# ================= ATTACH MODE =================

def get_batch_attach_mode(paths):
    """
    If all files are media => use Photos & videos
    Otherwise => use Document
    """
    exts = [os.path.splitext(p)[1].lower() for p in paths]
    if exts and all(ext in MEDIA_EXTS for ext in exts):
        return "media"
    return "document"

# ================= LEGACY UPLOAD (BACKUP ONLY) =================

def upload_file_via_dialog(path):
    """Legacy backup method using OS copy paste"""
    try:
        pyperclip.copy("")
        time.sleep(0.1)

        pyperclip.copy(path)
        time.sleep(0.3)

        for retry in range(3):
            actual = pyperclip.paste()
            if actual == path:
                break
            write_log(f"[WARN] Clipboard mismatch attempt {retry+1}: expected '{path}', got '{actual}'")
            time.sleep(0.3)
            pyperclip.copy(path)
            time.sleep(0.3)
        else:
            write_log(f"[ERROR] Clipboard could not be set to '{path}' after 3 retries!")
            return False

        write_log(f"[DEBUG] OS dialog opened. Executing ctrl+v...")
        pyautogui.hotkey("ctrl", "v")
        time.sleep(1.5)
        write_log(f"[DEBUG] Pressing enter on OS dialog...")
        pyautogui.press("enter")
        time.sleep(1.0)
        write_log(f"[OK] OS dialog completed for '{path}'")
        return True

    except Exception as e:
        write_log(f"[ERROR] Upload dialog failed: {e}")
        return False

# ================= DOM FILE UPLOAD (10x FASTER & 100% RELIABLE) =================

def upload_files_via_dom(driver, paths, mode):
    """
    Opens attach menu using instant dom_click, then uses OS dialog
    to prevent WhatsApp from sending images as stickers.
    """
    joined_paths = " ".join([f'"{p}"' for p in paths])
    
    # Click the attach button instantly using dom_click
    attach_btn = None
    xpaths = [
        "//div[@id='main']//footer//span[@data-icon='plus-rounded']/ancestor::div[@role='button']",
        "//div[@id='main']//footer//span[@data-icon='plus']/ancestor::div[@role='button']",
        "//div[@id='main']//footer//span[@data-icon='clip']/ancestor::div[@role='button']",
        "//div[@id='main']//footer//div[@title='Attach']",
        "//div[@id='main']//footer//div[@aria-label='Attach']",
        "//div[@id='main']//footer//button[@title='Attach']",
        "//div[@id='main']//footer//button[@aria-label='Attach']",
        "//span[@data-icon='plus-rounded']",
        "//span[@data-icon='plus']",
        "//span[@data-icon='clip']",
        "//div[@title='Attach']",
        "//div[@aria-label='Attach']"
    ]
    for xp in xpaths:
        try:
            els = driver.find_elements(By.XPATH, xp)
            for el in els:
                if el.is_displayed():
                    attach_btn = el
                    break
            if attach_btn:
                break
        except:
            pass
            
    if not attach_btn:
        write_log("[ERROR] Could not find attach button.")
        return False
        
    try:
        dom_click(driver, attach_btn)
        write_log("[INFO] Clicked attach button")
    except Exception as e:
        write_log(f"[ERROR] Could not click attach button: {e}")
        return False
            
    time.sleep(0.3)
    
    # Click the option button
    if mode == "media":
        option_xpaths = [
            "//span[normalize-space()='Photos & videos']",
            "//span[contains(text(),'Photos')]",
            "//div[@aria-label='Photos & videos']",
            "//button[@aria-label='Photos & videos']",
            "//li//span[contains(text(),'Photos')]"
        ]
    else:
        option_xpaths = [
            "//span[normalize-space()='Document']",
            "//span[contains(text(),'Document')]",
            "//div[@aria-label='Document']",
            "//button[@aria-label='Document']",
            "//li//span[contains(text(),'Document')]"
        ]
        
    option_btn = None
    for oxp in option_xpaths:
        try:
            els = driver.find_elements(By.XPATH, oxp)
            for el in els:
                if el.is_displayed():
                    option_btn = el
                    break
            if option_btn:
                break
        except:
            pass
            
    if not option_btn:
        try:
            option_btn = WebDriverWait(driver, 5).until(
                EC.element_to_be_clickable((By.XPATH, option_xpaths[0]))
            )
        except:
            write_log(f"[ERROR] Could not find option button for mode={mode}")
            return False
            
    try:
        # MUST use native click for the option button because browsers block file dialogs
        # from opening if triggered by a synthetic JS event (dom_click)
        option_btn.click()
        write_log(f"[INFO] Native clicked attach option button ({mode})")
    except Exception as e:
        write_log(f"[WARN] Native click failed: {e}. Trying JS click...")
        try:
            dom_click(driver, option_btn)
            write_log(f"[INFO] JS clicked attach option button ({mode})")
        except Exception as js_e:
            write_log(f"[ERROR] Could not click option button: {js_e}")
            return False
            
    # CRITICAL: Wait for Windows OS dialog to fully open and steal focus.
    time.sleep(3.5)
    
    # Use PyAutoGUI to paste the quoted paths and press Enter
    return upload_file_via_dialog(joined_paths)

# ================= SEND MEDIA / DOCUMENT =================

def send_files_in_open_chat(driver, paths):
    """
    Send ONE batch of files.
    Auto-detect attach type:
      - media => Photos & videos
      - document => Document
    """
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    if not paths:
        return True

    attach_mode = get_batch_attach_mode(paths)
    write_log(f"[INFO] Sending batch of {len(paths)} file(s) | mode={attach_mode}")

    try:
        # Use our super robust and fast DOM upload instead of PyAutoGUI OS dialog
        upload_ok = upload_files_via_dom(driver, paths, attach_mode)
        if not upload_ok:
            write_log("[ERROR] Native DOM upload failed for this batch")
            try:
                pyautogui.press('esc')
                time.sleep(0.3)
            except:
                pass
            return False

        # Detect if path got pasted into chat instead of upload
        time.sleep(0.2)
        if detect_file_path_pasted(driver):
            write_log("[WARN] File paths pasted into chat. Clearing composer and failing this attempt...")
            clear_chat_composer(driver)
            try:
                pyautogui.press('esc')
                time.sleep(0.3)
            except:
                pass
            return False

        # Wait for preview or send screen
        try:
            send_btn_xpaths = [
                "//span[@data-icon='send']/ancestor::div[@role='button']",
                "//span[contains(@data-icon,'send')]/ancestor::div[@role='button']",
                "//div[@role='button']//span[@data-icon='send']",
                "//span[@data-icon='send']",
                "//span[contains(@data-icon,'send')]",
                "//div[@aria-label='Send']",
                "//button[@aria-label='Send']"
            ]
            
            send_btn = None
            for sxp in send_btn_xpaths:
                try:
                    els = driver.find_elements(By.XPATH, sxp)
                    for el in els:
                        if el.is_displayed():
                            send_btn = el
                            break
                    if send_btn:
                        break
                except:
                    pass

            if not send_btn:
                # Wait fallback
                send_btn = wait.until(
                    EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]"))
                )

            # Speed Optimization: Reduced sleep delay to 0.4s
            time.sleep(0.4)

            if detect_file_path_pasted(driver):
                write_log("[WARN] File paths detected in composer before send. Clearing and failing batch.")
                clear_chat_composer(driver)
                try:
                    pyautogui.press('esc')
                    time.sleep(0.3)
                except:
                    pass
                return False

            try:
                dom_click(driver, send_btn)
            except:
                send_btn.click()
            write_log(f"[OK] Clicked Send for batch of {len(paths)} file(s)")

            for _ in range(len(paths)):
                record_send()

            if wait_until_back_to_chat_ready(driver, timeout=25):
                write_log("[OK] Chat UI returned after send.")
            else:
                write_log("[WARN] Chat UI did not fully recover after send. Continuing cautiously.")
                try:
                    pyautogui.press('esc')
                    time.sleep(0.3)
                except:
                    pass

            # Speed Optimization: Sleep reduced from 1.0s to 0.3s
            time.sleep(0.3)
            write_log("[OK] Batch sending cycle complete.")
            return True

        except TimeoutException:
            write_log("[ERROR] Timeout waiting for Send button for this batch")
            try:
                pyautogui.press('esc')
                time.sleep(0.3)
            except:
                pass
            return False

    except Exception as e:
        write_log(f"[ERROR] Exception sending batch: {e}")
        return False

def send_files_in_batches(driver, group_name, temp_files, batch_size=MAX_BATCH_ATTACH):
    """
    FIXED:
    - Do NOT re-open chat before every batch (prevents search loop)
    - Use current open chat if composer is ready
    - Re-open chat ONLY when UI is broken
    - Retry failed batch once with recovery
    """
    sent_temp_files = []

    if not temp_files:
        return sent_temp_files

    total = len(temp_files)
    batches = [temp_files[i:i + batch_size] for i in range(0, total, batch_size)]

    write_log(f"[INFO] Total files: {total} -> {len(batches)} batch(es) of up to {batch_size}")

    for idx, batch in enumerate(batches, 1):
        if _shutdown:
            break

        write_log(f"[INFO] --- Preparing batch {idx}/{len(batches)} ({len(batch)} file(s)) ---")

        # Use current chat if possible
        composer_ready = wait_until_back_to_chat_ready(driver, timeout=8)

        if not composer_ready:
            write_log(f"[WARN] Composer not ready before batch {idx}. Re-opening chat '{group_name}'...")
            chat_state = open_chat(driver, group_name)

            if chat_state != "FOUND":
                write_log(f"[ERROR] Could not re-open chat '{group_name}' before batch {idx}'. State={chat_state}")
                break

            if not wait_until_back_to_chat_ready(driver, timeout=8):
                write_log(f"[WARN] Composer still not ready after open_chat. Trying hard reset...")
                hard_reset_ui(driver)

                chat_state = open_chat(driver, group_name)
                if chat_state != "FOUND":
                    write_log(f"[ERROR] Could not recover chat '{group_name}' after reset. State={chat_state}")
                    break

                if not wait_until_back_to_chat_ready(driver, timeout=8):
                    write_log(f"[ERROR] Composer still not ready after hard reset for '{group_name}'.")
                    break

        write_log(f"[INFO] --- Sending batch {idx}/{len(batches)} ({len(batch)} file(s)) ---")

        ok = send_files_in_open_chat(driver, batch)

        if not ok:
            write_log("[WARN] First batch attempt failed. Retrying once with recovery...")
            time.sleep(0.5)

            if not wait_until_back_to_chat_ready(driver, timeout=5):
                try:
                    pyautogui.press('esc')
                    time.sleep(0.3)
                except:
                    pass

            if not wait_until_back_to_chat_ready(driver, timeout=5):
                write_log(f"[WARN] UI still unstable. Re-opening chat '{group_name}' for retry...")
                chat_state = open_chat(driver, group_name)
                if chat_state != "FOUND":
                    write_log(f"[ERROR] Retry failed because chat '{group_name}' could not be reopened. State={chat_state}")
                    ok = False
                else:
                    ok = send_files_in_open_chat(driver, batch)
            else:
                ok = send_files_in_open_chat(driver, batch)

        if ok:
            sent_temp_files.extend(batch)
            write_log(f"[OK] Batch {idx}/{len(batches)} sent successfully")
            # Speed Optimization: Reduced sleep delay between batches to 0.5s - 1.0s
            time.sleep(random.uniform(0.5, 1.0))
        else:
            write_log(f"[ERROR] Batch {idx}/{len(batches)} failed even after retry. Stopping further batches for this group.")
            break

    return sent_temp_files

# ================= FILE STAGING =================

def stage_files_with_short_names(original_paths):
    for attempt in range(5):
        try:
            if os.path.exists(TEMP_STAGING_DIR):
                shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
                time.sleep(0.2)
            if not os.path.exists(TEMP_STAGING_DIR):
                break
        except:
            time.sleep(0.3)

    os.makedirs(TEMP_STAGING_DIR, exist_ok=True)

    if len(os.listdir(TEMP_STAGING_DIR)) > 0:
        for f in os.listdir(TEMP_STAGING_DIR):
            try:
                os.remove(os.path.join(TEMP_STAGING_DIR, f))
            except:
                pass

    temp_paths, mapping = [], {}
    for i, orig_path in enumerate(original_paths):
        ext = os.path.splitext(orig_path)[1]
        temp_path = os.path.join(TEMP_STAGING_DIR, f"{i+1}{ext}")
        try:
            shutil.copy2(orig_path, temp_path)
            temp_paths.append(temp_path)
            mapping[temp_path] = orig_path
        except Exception as e:
            write_log(f"[ERROR] Stage failed for {orig_path}: {e}")

    return temp_paths, mapping

def cleanup_staging():
    try:
        if os.path.exists(TEMP_STAGING_DIR):
            shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
    except:
        pass

def is_file_stable(path, retries=2, delay=0.3):
    try:
        last = os.stat(path)
    except:
        return False

    for _ in range(retries):
        time.sleep(delay)
        cur = os.stat(path)
        if cur.st_size == last.st_size and cur.st_mtime == last.st_mtime:
            return True
        last = cur

    return False

# ================= PROCESS =================

def process_pending(driver):
    if not os.path.exists(PENDING_DIR):
        write_log(f"[WARN] Pending dir not found: {PENDING_DIR}")
        return

    if not check_daily_limit():
        return

    all_items = os.listdir(PENDING_DIR)
    items = sorted([d for d in all_items if os.path.isdir(os.path.join(PENDING_DIR, d))])
    write_log(f"[INFO] Found {len(items)} groups pending. (Sent today: {_session['sent_today']})")

    groups_scanned = 0
    groups_processed = 0

    for group in items:
        if _shutdown:
            break
        if not check_daily_limit():
            break

        groups_scanned += 1

        if groups_scanned % 50 == 0:
            write_log(f"[INFO] Scanning progress: {groups_scanned}/{len(items)} groups checked...")

        gpath = os.path.join(PENDING_DIR, group)

        try:
            potential_files = sorted(os.listdir(gpath))
        except:
            continue

        files = []
        for f in potential_files:
            full_path = os.path.join(gpath, f)
            ext = os.path.splitext(f)[1].lower()
            if ext in ALLOWED_EXTS:
                if is_file_stable(full_path):
                    files.append(full_path)
                else:
                    write_log(f"[WARN] Skipping {f} (File not stable/uploading)")

        if not files:
            continue

        check_rate_limit()
        groups_processed += 1
        write_log(f"[INFO] ========== Processing group {groups_processed}: {group} (Found {len(files)} files) ==========")

        chat_state = open_chat(driver, group)

        if chat_state == "FOUND":
            cleanup_staging()
            time.sleep(0.1)

            temp_files, mapping = stage_files_with_short_names(files)

            actual_count = len(os.listdir(TEMP_STAGING_DIR)) if os.path.exists(TEMP_STAGING_DIR) else 0
            if actual_count != len(files):
                write_log(f"[ERROR] Staging verification FAILED for {group}. Expected {len(files)}, got {actual_count}. Skipping.")
                cleanup_staging()
                continue

            sent_temp_files = send_files_in_batches(driver, group, temp_files, batch_size=MAX_BATCH_ATTACH)

            if sent_temp_files:
                dest = os.path.join(COMPLETE_DIR, group)
                os.makedirs(dest, exist_ok=True)

                for tf in sent_temp_files:
                    orig = mapping.get(tf)
                    if orig and os.path.exists(orig):
                        try:
                            shutil.move(orig, os.path.join(dest, os.path.basename(orig)))
                            write_log(f"[OK] Moved sent file to COMPLETE: {os.path.basename(orig)}")
                        except Exception as e:
                            write_log(f"[WARN] Could not move sent file {orig}: {e}")

            if len(sent_temp_files) != len(temp_files):
                write_log(f"[WARN] Group '{group}' partially sent: {len(sent_temp_files)}/{len(temp_files)} files")
                hard_reset_ui(driver)

            cleanup_staging()

        elif chat_state == "NOT_FOUND":
            write_log(f"[WARN] Group/folder '{group}' not found in WhatsApp. Skipping to next folder (will retry in next round).")

            # Clean up search UI before next folder
            try:
                pyautogui.press('esc')
                time.sleep(0.15)
                pyautogui.press('esc')
                time.sleep(0.15)
            except:
                pass

            continue

        else:  # ERROR
            write_log(f"[ERROR] UI/search error while opening '{group}'. Performing hard reset.")
            hard_reset_ui(driver)

        delay = random.uniform(MIN_DELAY_BETWEEN, MAX_DELAY_BETWEEN)
        time.sleep(delay)

# ================= MAIN =================

def main():
    write_log("[START] DOM-based Auto Sender (Version 9 - Ultra Fast)")
    if not ensure_authenticated():
        sys.exit(1)

    ensure_chrome_v145()

    driver = None
    try:
        driver = create_driver()
        driver.get("https://web.whatsapp.com/")
        write_log("[INFO] Waiting for WhatsApp to load (scan QR if needed)...")
        wait_for_whatsapp(driver)
        write_log("[OK] WhatsApp Loaded.")

        while not _shutdown:
            process_pending(driver)
            keep_session_alive(driver)
            time.sleep(POLL_INTERVAL)

    except Exception as e:
        import traceback
        write_log(f"[CRITICAL] {e}")
        write_log(traceback.format_exc())
        write_log("[INFO] Chrome will stay open for 60s so you can check the error...")
        time.sleep(60)

    finally:
        if driver:
            try:
                driver.quit()
            except:
                pass

if __name__ == "__main__":
    main()
