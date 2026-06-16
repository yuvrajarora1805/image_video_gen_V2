#!/usr/bin/env python3
"""
WhatsApp Auto Sender - SPEED EDITION (v11mar)
Based on the Full Stealth Edition, optimized for maximum sending speed.

Speed changes vs original:
1. Bezier mouse: 10-20 steps (was 30-60), 0.15-0.4s (was 0.4-1.2s)
2. Instant clipboard paste typing (was per-character with delays)
3. Idle simulation removed between sends (was 2-8s of random mouse moves)
4. All sleep() calls reduced by ~60-80%
5. File stability check: 2 retries x 0.5s (was 5 x 1.0s)
6. Upload dialog timing halved
7. Rate limits raised: 5000/hr, breaks every 3000 sends
8. Heartbeat only every 50 groups (was every group)
9. Inter-group delay: 0.3-0.8s (was 1-2s)
10. Hard reset ESC delay reduced
"""

import os
import time
import math
import shutil
import signal
import random
from datetime import datetime

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

WAIT_TIMEOUT  = 120
SEND_DELAY    = 1
POLL_INTERVAL = 1

# ── SPEED Rate limiting (relaxed for throughput) ──
MAX_SENDS_PER_HOUR  = 5000
MIN_DELAY_BETWEEN   = 0.3       # ⚡ was 1
MAX_DELAY_BETWEEN   = 0.8       # ⚡ was 2
LONG_BREAK_EVERY    = 3000      # ⚡ was 1000
LONG_BREAK_DURATION = (60, 120) # ⚡ was (120, 420) — now 1-2 min

IMAGE_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

LOG_FILE  = os.path.join(COMPLETE_DIR, "autosend.log")
_shutdown = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE    = 0.02   # ⚡ was 0.05

# ── Send counter for rate limiting ──
_sends_this_hour   = 0
_hour_start_time   = time.time()
_sends_since_break = 0

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

# ================= SIGNAL =================

def stop_handler(sig, frame):
    global _shutdown
    _shutdown = True
    write_log("[INFO] Shutdown requested")

signal.signal(signal.SIGINT,  stop_handler)
signal.signal(signal.SIGTERM, stop_handler)

# ================= RATE LIMITER =================

def check_rate_limit():
    """Enforce hourly send cap and mandatory long breaks."""
    global _sends_this_hour, _hour_start_time, _sends_since_break

    if time.time() - _hour_start_time >= 3600:
        _sends_this_hour = 0
        _hour_start_time = time.time()
        write_log("[INFO] Hourly counter reset.")

    if _sends_this_hour >= MAX_SENDS_PER_HOUR:
        wait_secs = 3600 - (time.time() - _hour_start_time)
        write_log(f"[RATE LIMIT] Hourly cap hit. Sleeping {wait_secs/60:.1f} minutes...")
        _interruptible_sleep(wait_secs)
        _sends_this_hour = 0
        _hour_start_time = time.time()

    if _sends_since_break >= LONG_BREAK_EVERY:
        duration = random.randint(*LONG_BREAK_DURATION)
        write_log(f"[RATE LIMIT] Taking a long break: {duration//60} min {duration%60} sec")
        _interruptible_sleep(duration)
        _sends_since_break = 0

def record_send():
    global _sends_this_hour, _sends_since_break
    _sends_this_hour  += 1
    _sends_since_break += 1

def _interruptible_sleep(seconds):
    """Sleep in small chunks so SIGINT is responsive."""
    end = time.time() + seconds
    while time.time() < end and not _shutdown:
        time.sleep(min(1.0, end - time.time()))

# ================= FAST BEZIER MOUSE MOVEMENT =================

def _bezier_point(t, p0, p1, p2, p3):
    """Cubic Bezier interpolation."""
    return (
        (1-t)**3 * p0[0] + 3*(1-t)**2*t * p1[0] + 3*(1-t)*t**2 * p2[0] + t**3 * p3[0],
        (1-t)**3 * p0[1] + 3*(1-t)**2*t * p1[1] + 3*(1-t)*t**2 * p2[1] + t**3 * p3[1],
    )

def human_move_to(x, y):
    """
    ⚡ SPEED: Faster Bezier curve — fewer steps, shorter duration.
    Still curved (not linear) for minimal stealth.
    """
    start_x, start_y = pyautogui.position()
    end_x, end_y     = int(x), int(y)

    cp1 = (start_x + random.randint(-40, 40), start_y + random.randint(-40, 40))  # ⚡ tighter curves
    cp2 = (end_x   + random.randint(-40, 40), end_y   + random.randint(-40, 40))

    steps    = random.randint(10, 20)       # ⚡ was 30-60
    duration = random.uniform(0.15, 0.4)    # ⚡ was 0.4-1.2

    for i in range(steps + 1):
        if _shutdown:
            break
        t = i / steps
        t_eased = (1 - math.cos(t * math.pi)) / 2
        bx, by  = _bezier_point(t_eased, (start_x, start_y), cp1, cp2, (end_x, end_y))
        pyautogui.moveTo(int(bx), int(by))
        time.sleep(duration / steps)

    # ⚡ Skip micro-correction overshoot — go straight to target
    pyautogui.moveTo(end_x, end_y)

# ================= FAST TYPING =================

def human_type(element, text):
    """
    ⚡ SPEED: Clipboard paste instead of per-character typing.
    Massively faster for long contact names / messages.
    """
    pyperclip.copy(text)
    element.send_keys(Keys.CONTROL, "v")
    time.sleep(random.uniform(0.05, 0.15))  # ⚡ tiny settle delay

# ================= IDLE SIMULATION (MINIMAL) =================

def simulate_idle(driver, duration=None):
    """
    ⚡ SPEED: Minimal idle — just a short pause, no mouse moves or scrolls.
    """
    if duration is None:
        duration = random.uniform(0.2, 0.5)  # ⚡ was 2-8
    time.sleep(duration)

# ================= DRIVER =================

def create_driver():
    """
    Launch Chrome with undetected-chromedriver.
    """
    opts = uc.ChromeOptions()
    opts.add_argument(f"--user-data-dir={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--lang=en-US")

    driver = uc.Chrome(options=opts, version_main=145)

    stealth_js = """
        Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
        Object.defineProperty(navigator, 'plugins', {
            get: () => [1, 2, 3, 4, 5],
        });
        Object.defineProperty(navigator, 'languages', {
            get: () => ['en-US', 'en'],
        });
        const originalQuery = window.navigator.permissions.query;
        window.navigator.permissions.query = (parameters) => (
            parameters.name === 'notifications' ?
                Promise.resolve({ state: Notification.permission }) :
                originalQuery(parameters)
        );
        window.chrome = {
            runtime: {},
            loadTimes: function() {},
            csi: function() {},
            app: {}
        };
    """
    try:
        driver.execute_cdp_cmd(
            "Page.addScriptToEvaluateOnNewDocument",
            {"source": stealth_js}
        )
    except Exception as e:
        write_log(f"[WARN] CDP stealth injection failed: {e}")

    return driver

# ================= SESSION HEARTBEAT =================

def keep_session_alive(driver):
    """Tiny scroll to keep session active."""
    try:
        sidebar = driver.find_elements(By.XPATH, "//div[@id='pane-side']")
        if sidebar:
            driver.execute_script("arguments[0].scrollTop += 5;", sidebar[0])
            time.sleep(0.15)   # ⚡ was 0.3
            driver.execute_script("arguments[0].scrollTop -= 5;", sidebar[0])
    except:
        pass

# ================= ERROR HANDLING =================

def hard_reset_ui(driver):
    """Recover from stuck UI using ESC."""
    try:
        write_log("[WARN] Initiating HARD UI RESET...")
        for _ in range(3):
            try:
                pyautogui.press('esc')
                time.sleep(random.uniform(0.3, 0.6))   # ⚡ was 0.8-1.5
            except:
                pass
        try:
            driver.execute_script("document.activeElement.blur();")
        except:
            pass
        wait_for_whatsapp(driver)
        write_log("[INFO] UI Reset Complete.")
    except Exception as e:
        write_log(f"[CRITICAL] UI reset failed: {e}")

# ================= WHATSAPP =================

def wait_for_whatsapp(driver):
    WebDriverWait(driver, WAIT_TIMEOUT).until(
        EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']"))
    )
    time.sleep(random.uniform(0.3, 0.6))   # ⚡ was 0.8-1.5

def open_chat(driver, name):
    wait = WebDriverWait(driver, WAIT_TIMEOUT)

    try:
        search = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//div[@contenteditable='true'][@data-tab='3']")
            )
        )
    except Exception:
        write_log(f"[WARN] Search box not found for {name}")
        return False

    loc  = search.location
    size = search.size
    human_move_to(loc['x'] + size['width'] // 2, loc['y'] + size['height'] // 2)
    time.sleep(random.uniform(0.05, 0.15))   # ⚡ was 0.1-0.3

    search.click()
    search.send_keys(Keys.CONTROL + "a")
    search.send_keys(Keys.BACKSPACE)
    time.sleep(0.1)   # ⚡ was 0.2

    human_type(search, name)   # ⚡ now uses clipboard paste
    time.sleep(random.uniform(0.2, 0.4))   # ⚡ was 0.4-0.9

    try:
        result = wait.until(
            EC.element_to_be_clickable((By.XPATH, f'//span[@title="{name}"]'))
        )
        r_loc  = result.location
        r_size = result.size
        human_move_to(r_loc['x'] + r_size['width'] // 2, r_loc['y'] + r_size['height'] // 2)
        time.sleep(random.uniform(0.05, 0.15))   # ⚡ was 0.1-0.25
        result.click()
        time.sleep(random.uniform(0.2, 0.4))   # ⚡ was 0.5-1.0

        # Name verification
        try:
            wait.until(EC.presence_of_element_located((By.XPATH, '//header//div[@role="button"]')))
            header_el   = wait.until(EC.visibility_of_element_located((By.TAG_NAME, "header")))
            header_lines = [l.strip() for l in header_el.text.split('\n') if l.strip()]
            write_log(f"[DEBUG] Header: {header_lines}")

            for line in header_lines:
                if line == name or line.startswith(name):
                    write_log(f"[OK] Chat Verified: {name}")
                    return True

            write_log(f"[WARN] Verification soft-fail — proceeding anyway")
            return True

        except Exception as e:
            write_log(f"[WARN] Header check error: {e}")
            return True

    except Exception as e:
        write_log(f"[ERROR] open_chat failed for {name}: {e}")
        return False

# ================= FILE STAGING =================

def stage_files_with_short_names(original_paths):
    if not os.path.exists(TEMP_STAGING_DIR):
        os.makedirs(TEMP_STAGING_DIR)
    for f in os.listdir(TEMP_STAGING_DIR):
        try:
            os.remove(os.path.join(TEMP_STAGING_DIR, f))
        except:
            pass

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
    try:
        if os.path.exists(TEMP_STAGING_DIR):
            shutil.rmtree(TEMP_STAGING_DIR)
    except:
        pass

def is_file_stable(path, retries=2, delay=0.5):
    """⚡ SPEED: 2 retries x 0.5s (was 5 x 1.0s) — max 1s wait instead of 5s."""
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

# ================= UPLOAD VIA DIALOG =================

def upload_file_via_dialog(path):
    try:
        pyperclip.copy(path)
        time.sleep(random.uniform(0.2, 0.4))   # ⚡ was 0.4-0.7
        if pyperclip.paste() != path:
            write_log("[WARN] Clipboard mismatch, retrying...")
            time.sleep(0.3)
            pyperclip.copy(path)

        pyautogui.hotkey("ctrl", "v")
        time.sleep(random.uniform(0.8, 1.2))   # ⚡ was 1.8-2.5
        pyautogui.press("enter")
    except Exception as e:
        write_log(f"[ERROR] Upload dialog failed: {e}")

# ================= SEND MEDIA =================

def send_images_in_open_chat(driver, paths):
    wait  = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    if not paths:
        return True
    if _shutdown:
        return False

    file_string = " ".join([f'"{p}"' for p in paths])
    write_log(f"[INFO] Sending {len(paths)} files")

    try:
        max_menu_retries = 3
        menu_open        = False

        for attempt in range(max_menu_retries):
            try:
                attach_btn = wait.until(
                    EC.presence_of_element_located((By.XPATH,
                        "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | "
                        "//span[@data-icon='plus'] | //span[@data-icon='clip'] | //div[@aria-label='Attach']"
                    ))
                )
                driver.execute_script("arguments[0].scrollIntoView({block:'center'});", attach_btn)
                time.sleep(random.uniform(0.15, 0.3))   # ⚡ was 0.3-0.6

                loc  = attach_btn.location
                size = attach_btn.size
                human_move_to(loc['x'] + size['width']//2, loc['y'] + size['height']//2)
                time.sleep(random.uniform(0.05, 0.15))   # ⚡ was 0.1-0.25

                driver.execute_script("arguments[0].click();", attach_btn)
                time.sleep(random.uniform(0.2, 0.4))   # ⚡ was 0.4-0.8

                photos_btn = WebDriverWait(driver, 5).until(
                    EC.element_to_be_clickable((By.XPATH,
                        "//span[normalize-space()='Photos & videos'] | //li//span[contains(text(),'Photos')]"
                    ))
                )
                p_loc  = photos_btn.location
                p_size = photos_btn.size
                human_move_to(p_loc['x'] + p_size['width']//2, p_loc['y'] + p_size['height']//2)
                time.sleep(random.uniform(0.05, 0.1))   # ⚡ was 0.1-0.25
                photos_btn.click()

                menu_open = True
                break

            except TimeoutException:
                write_log(f"[WARN] Attach menu retry {attempt+1}...")
                pyautogui.press('esc')
                time.sleep(random.uniform(0.3, 0.6))   # ⚡ was 0.8-1.5
            except Exception as e:
                write_log(f"[ERROR] Attach menu error: {e}")

        if not menu_open:
            write_log("[ERROR] Could not open attach menu")
            return False

        time.sleep(random.uniform(0.4, 0.7))   # ⚡ was 0.8-1.3
        upload_file_via_dialog(file_string)

        try:
            send_btn = wait.until(
                EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]"))
            )
            time.sleep(random.uniform(0.08, 0.2))   # ⚡ was 0.15-0.35

            s_loc  = send_btn.location
            s_size = send_btn.size
            human_move_to(s_loc['x'] + s_size['width']//2, s_loc['y'] + s_size['height']//2)
            time.sleep(random.uniform(0.05, 0.1))   # ⚡ was 0.1-0.25
            send_btn.click()

            write_log("[OK] Send clicked")

            # ⚡ SPEED FIX: Only wait 10s (was 60s) and don't block on it.
            # The old XPath matched the always-visible chat send button,
            # causing a full 60s hang every time. Now we just give it a
            # short grace period and move on.
            try:
                WebDriverWait(driver, 10).until(
                    EC.invisibility_of_element_located((By.XPATH,
                        "//div[contains(@class,'media')]//span[contains(@data-icon,'send')]"
                    ))
                )
            except TimeoutException:
                pass  # ⚡ Don't wait — just proceed

            time.sleep(random.uniform(0.3, 0.6))   # ⚡ was 1.0-2.0

        except TimeoutException:
            write_log("[ERROR] Timeout waiting for send button")
            return False

    except Exception as e:
        write_log(f"[ERROR] send_images_in_open_chat: {e}")
        return False

    return True

# ================= PROCESS =================

def process_pending(driver):
    global _sends_this_hour

    if not os.path.exists(PENDING_DIR):
        write_log(f"[WARN] PENDING_DIR not found: {PENDING_DIR}")
        time.sleep(5)
        return

    try:
        all_items = os.listdir(PENDING_DIR)
    except Exception as e:
        write_log(f"[ERROR] Cannot list PENDING_DIR: {e}")
        time.sleep(5)
        return

    write_log(f"[INFO] {len(all_items)} items in PENDING_DIR")

    groups_processed = 0

    for group in sorted(all_items):
        if _shutdown:
            return

        gpath = os.path.join(PENDING_DIR, group)
        if not os.path.isdir(gpath):
            continue

        try:
            all_files = os.listdir(gpath)
        except Exception as e:
            write_log(f"[ERROR] Cannot list group '{group}': {e}")
            continue

        files = []
        for f in sorted(all_files):
            full_path = os.path.join(gpath, f)
            ext       = os.path.splitext(f)[1].lower()
            if ext not in IMAGE_EXTS:
                continue
            if not is_file_stable(full_path):
                write_log(f"[WARN] Skipping unstable file: {f}")
                continue
            files.append(full_path)

        if not files:
            continue

        check_rate_limit()
        if _shutdown:
            return

        groups_processed += 1
        write_log(f"[INFO] ===== Group {groups_processed}: {group} ({len(files)} files) =====")

        try:
            if not open_chat(driver, group):
                write_log(f"[ERROR] Could not open chat: {group}. Skipping.")
                continue

            temp_files, mapping = stage_files_with_short_names(files)
            success = send_images_in_open_chat(driver, temp_files)

            if success:
                record_send()
                write_log(f"[OK] Sent to {group}")
                dest = os.path.join(COMPLETE_DIR, group)
                os.makedirs(dest, exist_ok=True)
                for temp_f in temp_files:
                    orig = mapping.get(temp_f)
                    if orig:
                        try:
                            shutil.move(orig, os.path.join(dest, os.path.basename(orig)))
                        except Exception as e:
                            write_log(f"[ERROR] Move failed: {e}")
            else:
                write_log(f"[ERROR] Send failed for {group}")
                hard_reset_ui(driver)

        except Exception as e:
            write_log(f"[ERROR] Group {group} crashed: {e}")
            hard_reset_ui(driver)

        cleanup_staging()

        # ⚡ SPEED: Minimal delay between groups
        delay = random.uniform(MIN_DELAY_BETWEEN, MAX_DELAY_BETWEEN)
        write_log(f"[INFO] Waiting {delay:.1f}s before next group...")

        # ⚡ SPEED: No idle simulation — just sleep the delay
        _interruptible_sleep(delay)

        # ⚡ SPEED: Heartbeat only every 50 groups (was every group)
        if groups_processed % 50 == 0:
            keep_session_alive(driver)

    write_log(f"[INFO] Scan complete. Processed {groups_processed} groups.")

# ================= MAIN =================

def main():
    write_log(f"[START] SPEED EDITION Auto Sender. Watching: {PENDING_DIR}")

    try:
        driver = create_driver()
        driver.get("https://web.whatsapp.com/")
        wait_for_whatsapp(driver)
        write_log("[OK] WhatsApp loaded. Watch mode started.")

        heartbeat_counter = 0

        while not _shutdown:
            process_pending(driver)

            heartbeat_counter += 1
            if heartbeat_counter >= 300:
                keep_session_alive(driver)
                heartbeat_counter = 0

            time.sleep(POLL_INTERVAL)

    except Exception as e:
        write_log(f"[CRITICAL] Main loop: {e}")
    finally:
        try:
            driver.quit()
        except:
            pass
        write_log("[INFO] Driver closed.")

if __name__ == "__main__":
    main()
