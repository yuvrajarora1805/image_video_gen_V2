#!/usr/bin/env python3
"""
WhatsApp Auto Sender (PYAUTOGUI FILE PICKER) - Video Optimized

✔ Uses pyautogui to enter file path
✔ Bypasses WhatsApp file-input limits
✔ One-by-one upload (most stable)
✔ Fixes search box accumulation
✔ Optimized for Video Sending (Robust Timeouts)
"""

import os
import time
import shutil
import signal
import random
from datetime import datetime

import pyautogui
import pyperclip

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from selenium.common.exceptions import TimeoutException

# ================= CONFIG =================

PROFILE_DIR = r"C:\temp\chrome-webdriver-profile"
PENDING_DIR = r"\\Main-pc\h\VIDEOS_DOWNLOAD_DIR"
COMPLETE_DIR = r"C:\Rannlab\autosend\COMPLETE_DIR"

# Increased timeouts for videos
WAIT_TIMEOUT = 120  # Increased global timeout
PREVIEW_WAIT = 5    # Increased wait for preview to load
SEND_DELAY = 1
POLL_INTERVAL = 2

# Supported Extensions
IMAGE_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

LOG_FILE = os.path.join(COMPLETE_DIR, "autosend.log")
_shutdown = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0.5  # Slower pyautogui for reliability

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

def is_file_stable(path, retries=5, delay=1.0): # Increased stability references
    try:
        last = os.stat(path)
    except Exception:
        return False
    for _ in range(retries):
        time.sleep(delay)
        cur = os.stat(path)
        if cur.st_size == last.st_size and cur.st_mtime == last.st_mtime:
            return True
        last = cur
    return False

# ================= DRIVER =================

def create_driver():
    opts = webdriver.ChromeOptions()
    opts.add_argument(f"user-data-dir={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--disable-blink-features=AutomationControlled")

    driver = webdriver.Chrome(
        service=Service(ChromeDriverManager().install()),
        options=opts
    )

    driver.execute_script(
        "Object.defineProperty(navigator,'webdriver',{get:()=>undefined})"
    )
    return driver

# ================= WHATSAPP =================

def wait_for_whatsapp(driver):
    WebDriverWait(driver, WAIT_TIMEOUT).until(
        EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']"))
    )
    sleep_jitter(1)

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

    # HARD CLEAR
    search.click()
    search.send_keys(Keys.CONTROL + "a")
    search.send_keys(Keys.BACKSPACE)
    time.sleep(0.5)

    for ch in name:
        search.send_keys(ch)
        time.sleep(random.uniform(0.05, 0.15))

    sleep_jitter(1.5)

    try:
        wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, f'//span[@title="{name}"]')
            )
        ).click()
        sleep_jitter(1.0)
        return True
    except Exception:
        return False

# ================= SEND MEDIA (PYAUTOGUI) =================

def upload_file_via_dialog(path):
    """Type file path into OS file dialog using pyautogui"""
    try:
        pyperclip.copy(path)
        time.sleep(0.5)
        pyautogui.hotkey("ctrl", "v")
        time.sleep(0.5)
        pyautogui.press("enter")
    except Exception as e:
        write_log(f"[ERROR] PyAutoGUI failed: {e}")

def send_images_in_open_chat(driver, paths):
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    write_log(f"[INFO] Sending {len(paths)} media files (pyautogui)")

    for path in paths:
        if _shutdown: break
        
        write_log(f"[INFO] Uploading {os.path.basename(path)}")

        try:
            # Click +
            wait.until(
                EC.element_to_be_clickable((By.XPATH, "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | //span[@data-icon='plus']"))
            ).click()
            sleep_jitter(0.5)

            # Click Photos & videos
            wait.until(
                EC.element_to_be_clickable(
                    (By.XPATH, "//span[normalize-space()='Photos & videos'] | //li//span[contains(text(),'Photos')]")
                )
            ).click()
            sleep_jitter(1.5) # Wait for dialog

            # OS dialog is open now
            upload_file_via_dialog(path)

            write_log(f"[INFO] Waiting for preview/processing of {os.path.basename(path)}")
            
            # Wait for the "Send" button to be clickable
            # This is critical for videos which take time to load/process
            try:
                send_btn = wait.until(
                    EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]"))
                )
                
                # Extra wait just in case
                sleep_jitter(1.0) 
                
                send_btn.click()
                write_log(f"[OK] Clicked Send for {os.path.basename(path)}")
                
                # Wait for upload to start/complete (Send button disappears or changes)
                time.sleep(2) 
                
            except TimeoutException:
                write_log(f"[ERROR] Timeout waiting for Send button for {path}")
                return False

        except Exception as e:
            write_log(f"[ERROR] Exception sending {path}: {e}")
            return False

        sleep_jitter(2) # Cooldown between files

    return True

# ================= PROCESS =================

def process_pending(driver):
    if not os.path.exists(PENDING_DIR):
        write_log(f"[WARN] Pending dir not found: {PENDING_DIR}")
        time.sleep(5)
        return

    for group in sorted(os.listdir(PENDING_DIR)):
        if _shutdown:
            return

        gpath = os.path.join(PENDING_DIR, group)
        if not os.path.isdir(gpath):
            continue

        files = [
            os.path.join(gpath, f)
            for f in sorted(os.listdir(gpath))
            if os.path.splitext(f)[1].lower() in IMAGE_EXTS
            and is_file_stable(os.path.join(gpath, f))
        ]

        if not files:
            continue

        write_log(f"[INFO] Processing group: {group}")

        if not open_chat(driver, group):
            write_log(f"[WARN] Chat not found: {group}")
            continue

        if send_images_in_open_chat(driver, files):
            dest = os.path.join(COMPLETE_DIR, group)
            os.makedirs(dest, exist_ok=True)
            for f in files:
                try:
                    shutil.move(f, os.path.join(dest, os.path.basename(f)))
                    write_log(f"[OK] Moved {f}")
                except Exception as e:
                    write_log(f"[ERROR] Failed to move {f}: {e}")

# ================= MAIN =================

def main():
    write_log(f"Starting Auto Sender. Watching: {PENDING_DIR}")
    
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
            driver.quit()
        except:
            pass
        write_log("[INFO] Driver closed")

if __name__ == "__main__":
    main()
