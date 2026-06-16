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

PROFILE_DIR      = r"C:\temp\chrome-webdriver-profile2"
PENDING_DIR      = r"\\Main-pc\h\VIDEOS_DOWNLOAD_DIR"
COMPLETE_DIR     = r"C:\Users\user\Desktop\autosend\vidcomp"
TEMP_STAGING_DIR = r"C:\t_W"

# ── Chrome 145 Config ──
CHROME_ZIP_URL           = "https://storage.googleapis.com/chrome-for-testing-public/145.0.7632.117/win64/chrome-win64.zip"
CHROMEDRIVER_ZIP_URL     = "https://storage.googleapis.com/chrome-for-testing-public/145.0.7632.117/win64/chromedriver-win64.zip"
CHROME_INSTALL_DIR       = r"C:\temp\chrome-145"
CHROME_BINARY_PATH       = os.path.join(CHROME_INSTALL_DIR, "chrome-win64", "chrome.exe")
CHROMEDRIVER_BINARY_PATH = os.path.join(CHROME_INSTALL_DIR, "chromedriver-win64", "chromedriver.exe")

# Increased timeouts for videos
WAIT_TIMEOUT  = 120
POLL_INTERVAL = 2

# Supported Extensions
IMAGE_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

LOG_FILE  = os.path.join(COMPLETE_DIR, "autosend.log")
_shutdown = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE    = 0.05  # Balanced speed/reliability

# ================= LOG =================

def write_log(msg):
    os.makedirs(COMPLETE_DIR, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(f"[{ts}] {msg}\n")
    print(msg)

# ================= SIGNAL =================

def stop_handler(sig, frame):
    global _shutdown
    _shutdown = True
    write_log("[INFO] Shutdown requested")

signal.signal(signal.SIGINT, stop_handler)
signal.signal(signal.SIGTERM, stop_handler)

# ================= UTIL =================

def sleep_jitter(v):
    time.sleep(max(0.2, random.uniform(v * 0.8, v * 1.2)))

def is_file_stable(path, retries=2, delay=0.5):
    try: last = os.stat(path)
    except: return False
    for _ in range(retries):
        time.sleep(delay)
        cur = os.stat(path)
        if cur.st_size == last.st_size and cur.st_mtime == last.st_mtime: return True
        last = cur
    return False

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
    driver.execute_script("arguments[0].click();", element)

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
    ensure_chrome_v145()
    write_log(f"[DEBUG] Using profile: {PROFILE_DIR}")
    opts = uc.ChromeOptions()
    opts.add_argument(f"--user-data-dir={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--lang=en-US")
    
    # ── Stability Flags ──
    opts.add_argument("--no-sandbox")
    opts.add_argument("--disable-dev-shm-usage")
    opts.add_argument("--disable-gpu")
    opts.add_argument("--disable-software-rasterizer")

    try:
        # use_subprocess=True is often more stable for initialization on Windows
        return uc.Chrome(
            options=opts,
            version_main=145,
            browser_executable_path=CHROME_BINARY_PATH,
            driver_executable_path=CHROMEDRIVER_BINARY_PATH,
            use_subprocess=True
        )
    except Exception as e:
        write_log(f"[CRITICAL] Driver failed to connect: {e}")
        write_log("[TIP] Ensure all other Chrome instances using this profile are CLOSED.")
        raise e

# ================= ERROR HANDLING =================

def hard_reset_ui(driver):
    """Recover from stuck UI states by refreshing"""
    try:
        write_log("[WARN] Initiating HARD UI RESET...")
        pyautogui.press('esc')
        time.sleep(0.4)
        pyautogui.press('esc')
        time.sleep(0.4)
        try: driver.execute_script("document.activeElement.blur();")
        except: pass
        time.sleep(0.5)
        driver.refresh()
        wait_for_whatsapp(driver)
        write_log("[INFO] UI Reset Complete.")
    except Exception as e:
        write_log(f"[CRITICAL] UI reset failed: {e}")

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
        time.sleep(2)
        search = None
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
            try:
                els = driver.find_elements(By.CSS_SELECTOR, sel)
                for el in els:
                    if el.is_displayed():
                        search = el; break
                if search: break
            except: continue
        
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
                try:
                    els = driver.find_elements(By.XPATH, xp)
                    for el in els:
                        if el.is_displayed():
                            search = el; break
                    if search: break
                except: continue
        
        if not search:
            write_log("[DEBUG] Search box not found in DOM. Forcing focus via Shortcut (Ctrl+Alt+/)...")
            try:
                driver.find_element(By.TAG_NAME, "body").send_keys(Keys.CONTROL, Keys.ALT, "/")
                time.sleep(1.5)
                els = driver.find_elements(By.CSS_SELECTOR, 'div[contenteditable="true"]')
                if els: search = els[0]
            except: pass
            
        if not search:
            write_log(f"[WARN] Search box not found for {name}")
            return False

        highlight_element(driver, search)
        loc = search.location; size = search.size
        human_move_to(loc['x'] + size['width'] // 2, loc['y'] + size['height'] // 2)

        search.click()
        search.send_keys(Keys.CONTROL + "a")
        search.send_keys(Keys.BACKSPACE)
        time.sleep(0.2)
        pyperclip.copy(name)
        search.send_keys(Keys.CONTROL, "v")
        time.sleep(random.uniform(0.8, 1.2))

        result = wait.until(EC.element_to_be_clickable((By.XPATH, f'//span[@title="{name}"]')))
        result.click()
        time.sleep(1.5)

        # ── Header Verification ──
        try:
            header_el = wait.until(EC.visibility_of_element_located((By.XPATH, "//div[@id='main']//header")))
            header_text = header_el.text
            if name.lower() in header_text.lower():
                write_log(f"[OK] Chat Verified: Found '{name}' in main header")
                return True
            else:
                write_log(f"[ERROR] Header verification FAILED for '{name}' (saw {header_text})")
                return False
        except Exception as e:
            write_log(f"[WARN] Chat verification logic error: {e}")
            return True

    except Exception as e:
        write_log(f"[ERROR] open_chat failed for {name}: {e}")
        return False

# ================= SEND MEDIA (PYAUTOGUI) =================

def upload_file_via_dialog(path):
    """Robust upload via Windows dialog with clipboard verification."""
    try:
        pyperclip.copy(path)
        time.sleep(0.3)
        # Verify clipboard
        for _ in range(3):
            if pyperclip.paste() == path: break
            time.sleep(0.3); pyperclip.copy(path)
        else:
            write_log(f"[ERROR] Clipboard could not be set to '{path}'")
            return False

        pyautogui.hotkey("ctrl", "v")
        time.sleep(random.uniform(1.2, 1.8))
        pyautogui.press("enter")
        return True
    except Exception as e:
        write_log(f"[ERROR] Upload dialog failed: {e}")
        return False

def send_images_in_open_chat(driver, paths):
    """Send all files at once using the Photos & Videos flow."""
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    if not paths: return True
    write_log(f"[INFO] Sending {len(paths)} files all-at-once")

    try:
        file_string = " ".join([f'"{p}"' for p in paths])
        max_menu_retries = 3
        menu_open = False

        for attempt in range(max_menu_retries):
            try:
                write_log(f"[INFO] Looking for attach button (Attempt {attempt+1})...")
                attach_btn = wait.until(EC.presence_of_element_located((By.XPATH, "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | //span[@data-icon='plus'] | //span[@data-icon='clip'] | //div[@aria-label='Attach']")))
                
                driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", attach_btn)
                time.sleep(0.5)
                
                loc = attach_btn.location; size = attach_btn.size
                human_move_to(loc['x'] + size['width'] // 2, loc['y'] + size['height'] // 2)
                time.sleep(0.1)

                dom_click(driver, attach_btn)
                time.sleep(0.5)
                
                photos_btn = WebDriverWait(driver, 5).until(EC.element_to_be_clickable((By.XPATH, "//span[normalize-space()='Photos & videos'] | //li//span[contains(text(),'Photos')]")))
                p_loc = photos_btn.location; p_size = photos_btn.size
                human_move_to(p_loc['x'] + p_size['width'] // 2, p_loc['y'] + p_size['height'] // 2)
                
                photos_btn.click()
                write_log(f"[INFO] 'Photos & videos' clicked")
                menu_open = True
                break
            except:
                pyautogui.press('esc')
                time.sleep(1.0)

        if not menu_open: return False

        time.sleep(1.2)
        if not upload_file_via_dialog(file_string): return False

        try:
            send_btn = wait.until(EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]")))
            time.sleep(1.2)
            send_btn.click()
            write_log(f"[OK] Clicked Send for batch")
            time.sleep(3.0) 
            pyautogui.press('esc')
        except TimeoutException:
            write_log(f"[ERROR] Timeout waiting for Send button")
            return False

    except Exception as e:
        write_log(f"[ERROR] Exception sending batch: {e}")
        hard_reset_ui(driver)
        return False

    return True

# ================= FILE STAGING =================

def stage_files_with_short_names(original_paths):
    for attempt in range(5):
        try:
            if os.path.exists(TEMP_STAGING_DIR):
                shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
                time.sleep(0.3)
            if not os.path.exists(TEMP_STAGING_DIR): break
        except: time.sleep(0.5)

    os.makedirs(TEMP_STAGING_DIR, exist_ok=True)
    temp_paths, mapping = [], {}
    for i, orig_path in enumerate(original_paths):
        ext       = os.path.splitext(orig_path)[1]
        temp_path = os.path.join(TEMP_STAGING_DIR, f"{i+1}{ext}")
        try:
            shutil.copy2(orig_path, temp_path)
            temp_paths.append(temp_path)
            mapping[temp_path] = orig_path
        except: pass
    return temp_paths, mapping

def cleanup_staging():
    try:
        if os.path.exists(TEMP_STAGING_DIR):
            shutil.rmtree(TEMP_STAGING_DIR, ignore_errors=True)
    except: pass

# ================= PROCESS =================

def process_pending(driver):
    if not os.path.exists(PENDING_DIR): 
        write_log(f"[WARN] Pending dir not found: {PENDING_DIR}")
        return

    all_items = os.listdir(PENDING_DIR)
    items = sorted([d for d in all_items if os.path.isdir(os.path.join(PENDING_DIR, d))])
    write_log(f"[INFO] Found {len(items)} groups pending.")

    for group in items:
        if _shutdown: break
        gpath = os.path.join(PENDING_DIR, group)
        
        try:
            potential_files = sorted(os.listdir(gpath))
        except: continue

        files = []
        for f in potential_files:
            full_path = os.path.join(gpath, f)
            ext = os.path.splitext(f)[1].lower()
            if ext in IMAGE_EXTS and is_file_stable(full_path):
                files.append(full_path)

        if not files: continue

        write_log(f"[INFO] Processing group: {group} ({len(files)} files)")

        if not open_chat(driver, group):
            write_log(f"[WARN] Chat not found or verified: {group}")
            continue

        # Staging
        temp_files, mapping = stage_files_with_short_names(files)
        
        if send_images_in_open_chat(driver, temp_files):
            dest = os.path.join(COMPLETE_DIR, group)
            os.makedirs(dest, exist_ok=True)
            for temp_f in temp_files:
                orig_f = mapping.get(temp_f)
                if orig_f:
                    try:
                        shutil.move(orig_f, os.path.join(dest, os.path.basename(orig_f)))
                        write_log(f"[OK] Moved {os.path.basename(orig_f)} to COMPLETE")
                    except Exception as e:
                        write_log(f"[ERROR] Failed to move {orig_f}: {e}")
        else:
            write_log(f"[ERROR] Batch send failed for {group}")
            hard_reset_ui(driver)

        cleanup_staging()
        time.sleep(1)

# ================= MAIN =================

def main():
    write_log(f"Starting Auto Sender (DOM OVERHAUL). Watching: {PENDING_DIR}")
    driver = None
    try:
        driver = create_driver()
        driver.get("https://web.whatsapp.com/")
        wait_for_whatsapp(driver)
        write_log("WhatsApp loaded. Watch mode started.")

        while not _shutdown:
            process_pending(driver)
            time.sleep(POLL_INTERVAL)
            
    except Exception as e:
        write_log(f"[CRITICAL] Main loop crashed: {e}")
    finally:
        try:
            if driver: driver.quit()
        except: pass
        write_log("[INFO] Driver closed")

if __name__ == "__main__":
    main()
