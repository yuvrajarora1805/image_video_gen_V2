#!/usr/bin/env python3
"""
WhatsApp Auto Sender - DOM EDITION (v20mar)
Faster, more reliable version using direct DOM interactions (Selenium/JS).
Avoids "sticker" issue by using the Photos & Videos attach method.
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
from selenium.common.exceptions import TimeoutException

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

IMAGE_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

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
        with open(SESSION_FILE, "w") as f: json.dump(data, f)
    except: pass

def _load_session():
    if os.path.exists(SESSION_FILE):
        try:
            with open(SESSION_FILE, "r") as f: return json.load(f)
        except: return None
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
            _session.update({"status": data.get("status", "error"), "message": data.get("message", "Session invalid")})
            return _session
    except Exception as e:
        last_val = saved.get("last_validated_at")
        if last_val:
            try:
                last_dt = datetime.fromisoformat(last_val)
                hours_since = (datetime.now() - last_dt).total_seconds() / 3600
                if hours_since < 24:
                    _session.update(saved); _session["status"] = "active"
                    write_log("[INFO] Running in offline grace mode")
                    return _session
            except: pass
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
    if not _session.get("username"): return
    try:
        requests.post(f"{API_BASE_URL}/log-usage", json={
            "username": _session["username"], "hwid": get_hwid(), "count": count
        }, timeout=5)
    except: pass

def check_daily_limit():
    if _session.get("daily_limit", 0) <= 0: return True
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
        _sends_this_hour = 0; _hour_start_time = time.time()
    if _sends_this_hour >= MAX_SENDS_PER_HOUR:
        wait_secs = 3600 - (time.time() - _hour_start_time)
        write_log(f"[RATE LIMIT] Hourly cap hit. Sleeping {wait_secs/60:.1f} min...")
        time.sleep(wait_secs)
        _sends_this_hour = 0; _hour_start_time = time.time()
    if _sends_since_break >= LONG_BREAK_EVERY:
        duration = random.randint(*LONG_BREAK_DURATION)
        write_log(f"[RATE LIMIT] Taking a long break: {duration}s")
        time.sleep(duration); _sends_since_break = 0

def record_send():
    global _sends_this_hour, _sends_since_break
    _sends_this_hour += 1; _sends_since_break += 1
    # Ensure it is treated as an int
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
    """
    ⚡ SPEED: Faster Bezier curve.
    Optional 'duration' for precision/visual tracking.
    """
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
    """Instant click via JavaScript."""
    driver.execute_script("arguments[0].click();", element)

def dom_type(element, text):
    """Direct typing via send_keys."""
    element.send_keys(Keys.CONTROL, "a")
    element.send_keys(Keys.BACKSPACE)
    element.send_keys(text)

# ================= CHROME =================

def ensure_chrome_v145():
    os.makedirs(CHROME_INSTALL_DIR, exist_ok=True)
    if not os.path.exists(CHROME_BINARY_PATH):
        write_log("[INFO] Downloading Chrome v145...")
        zip_path = os.path.join(CHROME_INSTALL_DIR, "chrome.zip")
        resp = requests.get(CHROME_ZIP_URL, stream=True, timeout=30)
        with open(zip_path, "wb") as f:
            for chunk in resp.iter_content(8192): f.write(chunk)
        zipfile.ZipFile(zip_path, 'r').extractall(CHROME_INSTALL_DIR)
        os.remove(zip_path)
    if not os.path.exists(CHROMEDRIVER_BINARY_PATH):
        write_log("[INFO] Downloading ChromeDriver v145...")
        zip_path = os.path.join(CHROME_INSTALL_DIR, "driver.zip")
        resp = requests.get(CHROMEDRIVER_ZIP_URL, stream=True, timeout=30)
        with open(zip_path, "wb") as f:
            for chunk in resp.iter_content(8192): f.write(chunk)
        zipfile.ZipFile(zip_path, 'r').extractall(CHROME_INSTALL_DIR)
        os.remove(zip_path)

def create_driver():
    opts = uc.ChromeOptions()
    opts.add_argument(f"--user-data-dir={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--lang=en-US")
    return uc.Chrome(
        options=opts,
        version_main=145,
        browser_executable_path=CHROME_BINARY_PATH,
        driver_executable_path=CHROMEDRIVER_BINARY_PATH
    )

def keep_session_alive(driver):
    try:
        sidebar = driver.find_elements(By.XPATH, "//div[@id='pane-side']")
        if sidebar: driver.execute_script("arguments[0].scrollTop += 10; arguments[0].scrollTop -= 10;", sidebar[0])
    except: pass

def hard_reset_ui(driver):
    """Recover from stuck UI states by refreshing"""
    try:
        write_log("[WARN] Initiating HARD UI RESET...")
        
        # Close any open menus / dialogs
        try:
            pyautogui.press('esc')
            time.sleep(0.4)
            pyautogui.press('esc')
            time.sleep(0.4)
        except:
            pass

        # Defocus broken elements
        try:
            driver.execute_script("document.activeElement.blur();")
            time.sleep(0.5)
        except:
            pass

        # Reload WhatsApp Web to guarantee clean state
        driver.refresh()
        write_log("[INFO] Page refreshed, waiting for reload...")
        
        # Wait for reload (extended time)
        wait_for_whatsapp(driver)
        write_log("[INFO] UI Reset Complete. WhatsApp reloaded.")

    except Exception as e:
        write_log(f"[CRITICAL] UI reset failed: {e}")

# ================= HIGHLIGHT (DOM POINTER) =================

def highlight_element(driver, element, color="red", duration=0.8):
    """Draws a visual border around the element to show what is being targeted."""
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

def open_chat(driver, name):
    write_log(f"[DEBUG] open_chat started for: {name}")
    wait = WebDriverWait(driver, 20)
    try:
        # Find Search Box
        write_log("[DEBUG] Looking for search box...")
        time.sleep(4) # Give UI time to resolve after refresh/load
        
        search = None
        try:
            # 1. Try Specific Input Selectors (Direct from user snippet & Lexical)
            # Tag: <input data-tab="3" aria-label="Search or start a new chat">
            css_selectors = [
                'div[contenteditable="true"][data-tab="3"]',
                'div#side div[contenteditable="true"]',
                'div.lexical-rich-text-input div[contenteditable="true"]',
                'p.selectable-text.copyable-text',
                'input[data-tab="3"]', 
                'input[aria-label*="Search"]',
                'p[aria-label*="Search"]',
                'div[title="Search input element"]'
            ]
            for sel in css_selectors:
                els = driver.find_elements(By.CSS_SELECTOR, sel)
                if els:
                    # Filter for visible elements
                    for el in els:
                        if el.is_displayed():
                            search = el
                            write_log(f"[DEBUG] Found search box via CSS: {sel}")
                            break
                if search: break
            
            # 2. Try XPath Fallback
            if not search:
                xpaths = [
                    "//div[@contenteditable='true'][@data-tab='3']",
                    "//div[@id='side']//div[@contenteditable='true']",
                    "//p[contains(@class, 'selectable-text') and contains(@class, 'copyable-text')]",
                    "//div[@title='Search input element']",
                    "//p[contains(@aria-label, 'Search')]",
                    "//input[@data-tab='3']", 
                    "//input[contains(@aria-label, 'Search')]"
                ]
                for xp in xpaths:
                    els = driver.find_elements(By.XPATH, xp)
                    if els:
                        for el in els:
                            if el.is_displayed():
                                search = el
                                write_log(f"[DEBUG] Found search box via XPath: {xp}")
                                break
                    if search: break
            
            # 3. Try Keyboard Shortcut Fallback
            if not search:
                write_log("[DEBUG] Search box not found in DOM. Forcing focus via Shortcut (Ctrl+Alt+/)...")
                driver.find_element(By.TAG_NAME, "body").send_keys(Keys.CONTROL, Keys.ALT, "/")
                time.sleep(1.5)
                els = driver.find_elements(By.CSS_SELECTOR, 'div[contenteditable="true"]')
                if els:
                    search = els[0]
                    write_log("[DEBUG] Found search box after keyboard shortcut")
            
            if not search:
                # ABSOLUTE FAILURE: Save evidence
                sc_path = r"C:\temp\wa_error_search.png"
                driver.save_screenshot(sc_path)
                write_log(f"[CRITICAL] FAILED to find search box. Check screenshot: {sc_path}")
                return False

        except Exception as intern_e:
            write_log(f"[ERROR] Internal error while searching: {intern_e}")
            return False

        write_log("[DEBUG] Highlighting search box...")
        highlight_element(driver, search, color="red", duration=0.8)
        
        # Robot Move to Search
        loc = search.location; size = search.size
        write_log(f"[DEBUG] Moving mouse to {loc}...")
        human_move_to(loc['x'] + size['width'] // 2, loc['y'] + size['height'] // 2)
        time.sleep(0.1)

        # HARD CLEAR
        write_log("[DEBUG] Clicking and clearing search box...")
        search.click()
        search.send_keys(Keys.CONTROL + "a")
        search.send_keys(Keys.BACKSPACE)
        time.sleep(0.2)

        # Type Name (Fast Clipboard Paste)
        write_log(f"[DEBUG] Typing name '{name}'...")
        pyperclip.copy(name)
        search.send_keys(Keys.CONTROL, "v")
        time.sleep(random.uniform(0.5, 0.8))

        # 1. Click Result
        write_log(f"[DEBUG] Waiting for search result for '{name}'...")
        try:
            # Click chat
            result = wait.until(
                EC.element_to_be_clickable(
                    (By.XPATH, f'//span[@title="{name}"]')
                )
            )
            write_log(f"[DEBUG] Search result found, clicking: {name}")
            result.click()
            time.sleep(random.uniform(0.8, 1.2)) # Wait for chat load
            
            # 2. CRITICAL: STRICT NAME VERIFICATION
            try:
                # Give the header a moment to update from the previous state
                time.sleep(1.5)
                
                # Robust Verification: Search ONLY the main chat header
                try:
                    # Get the header element inside #main to avoid the sidebar one
                    header_el = wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@id='main']//header")))
                    header_text = header_el.text
                    
                    # Split into lines
                    header_lines = [line.strip() for line in header_text.split('\n') if line.strip()]
                    write_log(f"[DEBUG] Main Chat Header lines: {header_lines}")

                    # Check if name is anywhere in those header lines
                    found = False
                    for line in header_lines:
                        # Exact or Case-insensitive match
                        if name.lower() in line.lower() or line.lower() in name.lower():
                             found = True
                             break
                    
                    if not found:
                         # Deep search inside header spans (for elements like _ao3e titles)
                         write_log("[DEBUG] Searching deep in header spans...")
                         spans = header_el.find_elements(By.XPATH, ".//span[contains(@class, '_ao3e')] | .//span")
                         for s in spans:
                             try:
                                 s_txt = s.text.strip().replace("...", "") # Remove generic ellipses
                                 if s_txt:
                                      # Smart Partial Match: either name contains span_text OR span_text contains name
                                      if (s_txt.lower() in name.lower()) or (name.lower() in s_txt.lower()):
                                           # Require at least 4 characters to avoid false matches on single digits like "4"
                                           if len(s_txt) >= 4:
                                               found = True
                                               break
                             except: pass

                    if found:
                         write_log(f"[OK] Chat Verified: Found '{name}' in main header")
                         return True
                    else:
                         # ERROR: Do not send if name mismatch
                         write_log(f"[ERROR] Main Header verification FAILED for '{name}' (saw {header_lines})")
                         write_log(f"[ERROR] Aborting send for this group to avoid wrong contact.")
                         return False
                    
                except Exception as e:
                    write_log(f"[WARN] Chat verification logic error: {e}")
                    return True
                
            except Exception as e:
                write_log(f"[ERROR] Chat verification failed for {name}: {e}")
                return False

        except Exception as e:
            write_log(f"[ERROR] click search result failed for {name}: {e}")
            return False

    except Exception as e:
        write_log(f"[ERROR] open_chat failed for {name}: {e}")
        return False

# ================= UPLOAD =================

def upload_file_via_dialog(path):
    """Robust upload via Windows dialog with clipboard verification."""
    try:
        # 1. Clear clipboard to be safe
        pyperclip.copy("")
        time.sleep(0.1)

        # 2. Copy the actual path (with quotes for safety)
        pyperclip.copy(path)
        time.sleep(0.3)

        # 3. Verify clipboard
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

        # 4. Paste and Enter
        pyautogui.hotkey("ctrl", "v")
        time.sleep(random.uniform(1.2, 1.8))
        pyautogui.press("enter")
        return True
    except Exception as e:
        write_log(f"[ERROR] Upload dialog failed: {e}")
        return False

# ================= SEND MEDIA =================

def send_images_in_open_chat(driver, paths):
    """Send all files at once using the Photos & Videos flow (prevents stickers)."""
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    if not paths:
        return True

    write_log(f"[INFO] Sending {len(paths)} files all-at-once")

    try:
        # Join all paths for the Windows dialog: "path1" "path2" "path3"
        file_string = " ".join([f'"{p}"' for p in paths])
        max_menu_retries = 3
        menu_open = False

        for attempt in range(max_menu_retries):
            try:
                write_log(f"[INFO] Looking for attach button (Attempt {attempt+1})...")
                
                # Updated Selectors based on provided script
                attach_btn = wait.until(
                    EC.presence_of_element_located((By.XPATH, "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | //span[@data-icon='plus'] | //span[@data-icon='clip'] | //div[@aria-label='Attach']"))
                )
                
                # Scroll into view just in case
                driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", attach_btn)
                time.sleep(0.5)
                
                # Robot Move to Attach
                loc = attach_btn.location; size = attach_btn.size
                human_move_to(loc['x'] + size['width'] // 2, loc['y'] + size['height'] // 2)
                time.sleep(random.uniform(0.1, 0.25))

                # JS Click (Bypasses overlays/visibility checks)
                driver.execute_script("arguments[0].click();", attach_btn)
                write_log(f"[INFO] Attach button clicked via JS")
                
                # Short wait for menu to animate
                time.sleep(0.5)
                
                # Try to find Photos & videos
                write_log(f"[INFO] Looking for 'Photos & videos' option...")
                photos_btn = WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable(
                        (By.XPATH, "//span[normalize-space()='Photos & videos'] | //li//span[contains(text(),'Photos')]")
                    )
                )

                # Move to Photos & videos
                p_loc = photos_btn.location; p_size = photos_btn.size
                human_move_to(p_loc['x'] + p_size['width'] // 2, p_loc['y'] + p_size['height'] // 2)
                time.sleep(random.uniform(0.1, 0.25))

                photos_btn.click()
                write_log(f"[INFO] 'Photos & videos' clicked")
                menu_open = True
                break # Success
                
            except TimeoutException:
                write_log(f"[WARN] Menu didn't open or checking failed, retrying attach click...")
                # Try pressing ESC to close any partial menu state before retrying
                try:
                    pyautogui.press('esc')
                    time.sleep(1.0)
                except:
                    pass
            except Exception as e:
                    write_log(f"[ERROR] Error opening menu: {e}")

        if not menu_open:
            write_log(f"[ERROR] Failed to open Attach menu after {max_menu_retries} attempts")
            return False

        # ── 3. UPLOAD VIA DIALOG (Robust clipboard paste) ──
        # Mandatory sleep to ensure Windows dialog has focus
        time.sleep(1.2)
        upload_ok = upload_file_via_dialog(file_string)
        if not upload_ok:
            write_log("[ERROR] Upload failed, skipping group")
            pyautogui.press('esc')
            return False

        # ── 4. SEND VIA ENTER (Manual Workflow) ──
        try:
            # Wait for preview screen to appear (send icon must visible)
            send_btn = wait.until(EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]")))
            time.sleep(random.uniform(1.0, 1.5)) # Give it a moment to load all thumbnails

            # Mimic manual "again enter like this" for sending everything at once
            send_btn.click()
            write_log(f"[OK] Clicked Send for batch")
            
            # Record base count
            for _ in range(len(paths)): record_send()
            
            # Wait briefly for upload to start/process (avoid 60s timeout)
            time.sleep(3.0) 
            
            # Clear any UI overlays
            pyautogui.press('esc')
            time.sleep(0.5)
            write_log("[OK] Batch sending cycle complete.")

        except TimeoutException:
            write_log(f"[ERROR] Timeout waiting for Send button for batch")
            return False

    except Exception as e:
        write_log(f"[ERROR] Exception sending batch: {e}")
        hard_reset_ui(driver)
        return False

    return True

# ================= FILE STAGING =================

def stage_files_with_short_names(original_paths):
    """Robust staging: ensure folder is 100% deleted with retries, then recreate fresh."""
    for attempt in range(5):
        try:
            if os.path.exists(TEMP_STAGING_DIR):
                shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
                time.sleep(0.3)
            if not os.path.exists(TEMP_STAGING_DIR):
                break
        except:
            time.sleep(0.5)

    os.makedirs(TEMP_STAGING_DIR, exist_ok=True)
    # Final check: Must be empty
    if len(os.listdir(TEMP_STAGING_DIR)) > 0:
        for f in os.listdir(TEMP_STAGING_DIR):
            try: os.remove(os.path.join(TEMP_STAGING_DIR, f))
            except: pass

    temp_paths, mapping = [], {}
    for i, orig_path in enumerate(original_paths):
        ext       = os.path.splitext(orig_path)[1]
        temp_path = os.path.join(TEMP_STAGING_DIR, f"{i+1}{ext}")
        try:
            shutil.copy2(orig_path, temp_path)
            temp_paths.append(temp_path)
            mapping[temp_path] = orig_path
        except Exception as e:
            write_log(f"[ERROR] Stage failed for {orig_path}: {e}")
    return temp_paths, mapping

def cleanup_staging():
    """Wipe the staging directory."""
    try:
        if os.path.exists(TEMP_STAGING_DIR):
            shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
    except: pass

def is_file_stable(path, retries=2, delay=0.5):
    try: last = os.stat(path)
    except: return False
    for _ in range(retries):
        time.sleep(delay)
        cur = os.stat(path)
        if cur.st_size == last.st_size and cur.st_mtime == last.st_mtime: return True
        last = cur
    return False

# ================= PROCESS =================

def process_pending(driver):
    if not os.path.exists(PENDING_DIR): 
        write_log(f"[WARN] Pending dir not found: {PENDING_DIR}")
        return
    if not check_daily_limit(): return

    all_items = os.listdir(PENDING_DIR)
    items = sorted([d for d in all_items if os.path.isdir(os.path.join(PENDING_DIR, d))])
    write_log(f"[INFO] Found {len(items)} groups pending. (Sent today: {_session['sent_today']})")

    groups_scanned = 0
    groups_processed = 0

    for group in items:
        if _shutdown: break
        if not check_daily_limit(): break
        groups_scanned += 1
        
        if groups_scanned % 50 == 0:
            write_log(f"[INFO] Scanning progress: {groups_scanned}/{len(items)} groups checked...")

        gpath = os.path.join(PENDING_DIR, group)
        
        # Stability Check & Filtering
        try:
            potential_files = sorted(os.listdir(gpath))
        except:
            continue

        files = []
        for f in potential_files:
            full_path = os.path.join(gpath, f)
            ext = os.path.splitext(f)[1].lower()
            if ext in IMAGE_EXTS:
                if is_file_stable(full_path):
                    files.append(full_path)
                else:
                    write_log(f"[WARN] Skipping {f} (File not stable/uploading)")

        if not files: continue

        check_rate_limit()
        groups_processed += 1
        write_log(f"[INFO] ========== Processing group {groups_processed}: {group} (Found {len(files)} files) ==========")

        if open_chat(driver, group):
            # 1. Clear staging FIRST to be extra safe
            cleanup_staging()
            time.sleep(0.1)

            # 2. Stage files with short filenames (1.jpg, etc.)
            temp_files, mapping = stage_files_with_short_names(files)

            # 3. VERIFY staging was clean and correct
            actual_count = len(os.listdir(TEMP_STAGING_DIR)) if os.path.exists(TEMP_STAGING_DIR) else 0
            if actual_count != len(files):
                write_log(f"[ERROR] Staging verification FAILED for {group}. Expected {len(files)}, got {actual_count}. Skipping.")
                cleanup_staging()
                continue

            # 4. SEND using the robust hidden-input method
            if send_images_in_open_chat(driver, temp_files):
                dest = os.path.join(COMPLETE_DIR, group)
                os.makedirs(dest, exist_ok=True)
                for tf in temp_files:
                    orig = mapping.get(tf)
                    if orig and os.path.exists(orig):
                        try:
                            shutil.move(orig, os.path.join(dest, os.path.basename(orig)))
                        except Exception as e:
                            write_log(f"[WARN] Could not move {orig}: {e}")
            else:
                hard_reset_ui(driver)

            # 5. Clean staging after each group
            cleanup_staging()

        else:
            hard_reset_ui(driver)

        delay = random.uniform(MIN_DELAY_BETWEEN, MAX_DELAY_BETWEEN)
        time.sleep(delay)

# ================= MAIN =================

def main():
    write_log("[START] DOM-based Auto Sender")
    if not ensure_authenticated(): sys.exit(1)

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
            time.sleep(POLL_INTERVAL)
    except Exception as e:
        import traceback
        write_log(f"[CRITICAL] {e}")
        write_log(traceback.format_exc())
        write_log("[INFO] Chrome will stay open for 60s so you can check the error...")
        time.sleep(60)
    finally:
        if driver:
            try: driver.quit()
            except: pass

if __name__ == "__main__":
    main()
