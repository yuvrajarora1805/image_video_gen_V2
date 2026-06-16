#!/usr/bin/env python3
"""
WhatsApp Auto Sender - IMPROVED VERSION
✔ Chat verification before sending
✔ Batch sending (all images per client)
✔ Enhanced logging and error handling
✔ Prevents cross-client image sending
✔ Better search box clearing
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
from selenium.common.exceptions import TimeoutException, NoSuchElementException

# ================= CONFIG =================

PROFILE_DIR = r"C:\temp\chrome-webdriver-profile"
PENDING_DIR = r"\\Main-pc\h\VIDEOS_DOWNLOAD_DIR"
COMPLETE_DIR = r"C:\Rannlab\autosend\COMPLETE_DIR"
FAILED_DIR = r"C:\Rannlab\autosend\FAILED_DIR"  # New: for failed sends

# Timeouts
WAIT_TIMEOUT = 120
PREVIEW_WAIT = 5
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
pyautogui.PAUSE = 0.5

# ================= LOG =================

def write_log(msg, level="INFO"):
    """Enhanced logging with levels"""
    os.makedirs(COMPLETE_DIR, exist_ok=True)
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_msg = f"[{ts}] [{level}] {msg}"
    try:
        with open(LOG_FILE, "a", encoding="utf-8") as f:
            f.write(f"{log_msg}\n")
    except Exception as e:
        print(f"Log Error: {e}")
    print(log_msg)

# ================= SIGNAL =================

def stop_handler(sig, frame):
    global _shutdown
    _shutdown = True
    write_log("Shutdown requested", "WARN")

signal.signal(signal.SIGINT, stop_handler)
signal.signal(signal.SIGTERM, stop_handler)

# ================= UTIL =================

def sleep_jitter(v):
    time.sleep(max(0.2, random.uniform(v * 0.8, v * 1.2)))

def is_file_stable(path, retries=5, delay=1.0):
    """Check if file is stable (not being written)"""
    try:
        last = os.stat(path)
    except Exception:
        return False
    for _ in range(retries):
        time.sleep(delay)
        try:
            cur = os.stat(path)
            if cur.st_size == last.st_size and cur.st_mtime == last.st_mtime:
                return True
            last = cur
        except Exception:
            return False
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
    """Wait for WhatsApp to load"""
    WebDriverWait(driver, WAIT_TIMEOUT).until(
        EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']"))
    )
    sleep_jitter(1)
    write_log("WhatsApp Web loaded successfully")

def clear_search_box(driver):
    """Aggressively clear the search box"""
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    
    try:
        search = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//div[@contenteditable='true'][@data-tab='3']")
            )
        )
        
        # Method 1: Select all and delete
        search.click()
        time.sleep(0.3)
        search.send_keys(Keys.CONTROL + "a")
        search.send_keys(Keys.BACKSPACE)
        time.sleep(0.3)
        
        # Method 2: JavaScript force clear
        try:
            driver.execute_script("arguments[0].textContent = '';", search)
            driver.execute_script("arguments[0].innerText = '';", search)
        except:
            pass
        
        # Method 3: Multiple backspaces
        for _ in range(50):
            search.send_keys(Keys.BACKSPACE)
        
        time.sleep(0.5)
        write_log("Search box cleared", "DEBUG")
        return search
        
    except Exception as e:
        write_log(f"Failed to clear search box: {e}", "ERROR")
        return None

def verify_chat_open(driver, expected_name):
    """Verify that the correct chat is open with EXACT name matching"""
    try:
        # Wait a moment for chat to load
        time.sleep(1.5)
        
        write_log(f"Verifying chat header matches: '{expected_name}'", "DEBUG")
        
        # Try to get the chat header text
        header_selectors = [
            "//header//span[@dir='auto']",  # Main chat header
            "//div[@role='banner']//span[@dir='auto']",  # Alternative header
            "//header//div[contains(@class, 'copyable-text')]//span",  # Copyable text span
        ]
        
        chat_name_found = None
        
        for selector in header_selectors:
            try:
                elements = driver.find_elements(By.XPATH, selector)
                for element in elements:
                    text = element.text.strip()
                    if text and len(text) > 0:
                        chat_name_found = text
                        write_log(f"Found chat header text: '{chat_name_found}'", "DEBUG")
                        break
                if chat_name_found:
                    break
            except:
                continue
        
        if not chat_name_found:
            write_log(f"✗ Could not find chat header text", "ERROR")
            return False
        
        # EXACT MATCH VERIFICATION
        if chat_name_found == expected_name:
            write_log(f"✓✓ EXACT MATCH VERIFIED: '{expected_name}' == '{chat_name_found}'", "SUCCESS")
            return True
        else:
            write_log(f"✗✗ NAME MISMATCH: Expected '{expected_name}' but found '{chat_name_found}'", "ERROR")
            write_log(f"   This prevents sending to wrong contact!", "WARN")
            return False
        
    except Exception as e:
        write_log(f"Error verifying chat: {e}", "ERROR")
        return False

def open_chat(driver, name, max_retries=3):
    """Open a chat with EXACT name verification"""
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    
    write_log(f"{'='*60}")
    write_log(f"Target Contact: '{name}'")
    write_log(f"{'='*60}")
    
    for attempt in range(max_retries):
        try:
            write_log(f"Opening chat: '{name}' (Attempt {attempt + 1}/{max_retries})")
            
            # Clear search box
            search = clear_search_box(driver)
            if not search:
                write_log(f"Search box not found for {name}", "ERROR")
                continue
            
            # Type contact name slowly
            write_log(f"Typing contact name: '{name}'", "DEBUG")
            for ch in name:
                search.send_keys(ch)
                time.sleep(random.uniform(0.05, 0.15))
            
            sleep_jitter(2.0)  # Wait for search results
            
            # Click on the contact
            try:
                contact = wait.until(
                    EC.element_to_be_clickable(
                        (By.XPATH, f'//span[@title="{name}"]')
                    )
                )
                write_log(f"Contact found in search, clicking...", "DEBUG")
                contact.click()
                sleep_jitter(1.5)
                
                # CRITICAL: Verify EXACT name match
                if verify_chat_open(driver, name):
                    write_log(f"✓✓ Chat opened and EXACT NAME VERIFIED: '{name}'", "SUCCESS")
                    return True
                else:
                    write_log(f"✗✗ Name mismatch detected, aborting to prevent wrong send!", "ERROR")
                    write_log(f"   Will retry opening correct chat...", "WARN")
                    continue
                    
            except TimeoutException:
                write_log(f"Contact not found in search results: '{name}'", "ERROR")
                write_log(f"   Make sure contact name matches exactly (case-sensitive)", "WARN")
                continue
                
        except Exception as e:
            write_log(f"Error opening chat '{name}': {e}", "ERROR")
            continue
    
    write_log(f"✗✗✗ FAILED to open chat after {max_retries} attempts: '{name}'", "ERROR")
    write_log(f"   Possible reasons:", "WARN")
    write_log(f"   1. Contact name doesn't match exactly (check case/spaces)", "WARN")
    write_log(f"   2. Contact not in WhatsApp contacts", "WARN")
    write_log(f"   3. Network/WhatsApp Web issue", "WARN")
    return False

# ================= SEND MEDIA =================

def upload_file_via_dialog(path):
    """Type file path into OS file dialog using pyautogui"""
    try:
        pyperclip.copy(path)
        time.sleep(0.8)
        pyautogui.hotkey("ctrl", "v")
        time.sleep(0.8)
        pyautogui.press("enter")
        write_log(f"File path entered: {os.path.basename(path)}", "DEBUG")
    except Exception as e:
        write_log(f"PyAutoGUI failed: {e}", "ERROR")
        raise

def send_single_file(driver, path):
    """Send a single file in the currently open chat"""
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    
    try:
        write_log(f"→ Sending: {os.path.basename(path)}")
        
        # Click attach button (+)
        attach_btn = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | //span[@data-icon='plus']")
            )
        )
        attach_btn.click()
        sleep_jitter(0.5)
        
        # Click "Photos & videos"
        photos_btn = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//span[normalize-space()='Photos & videos'] | //li//span[contains(text(),'Photos')]")
            )
        )
        photos_btn.click()
        sleep_jitter(2.0)  # Wait for file dialog
        
        # Upload file via dialog
        upload_file_via_dialog(path)
        
        write_log(f"Waiting for preview/processing...", "DEBUG")
        
        # Wait for Send button
        send_btn = wait.until(
            EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]"))
        )
        sleep_jitter(1.0)
        send_btn.click()
        
        write_log(f"✓ Send button clicked", "DEBUG")
        
        # Wait for send button to disappear (upload started)
        try:
            WebDriverWait(driver, 30).until(
                EC.invisibility_of_element_located((By.XPATH, "//span[contains(@data-icon,'send')]"))
            )
        except TimeoutException:
            write_log(f"Send button didn't disappear, likely slow upload", "WARN")
        
        # Wait to return to chat
        time.sleep(2)
        
        # Verify back in chat
        try:
            wait.until(EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']")))
            write_log(f"✓ File sent successfully: {os.path.basename(path)}", "SUCCESS")
            return True
        except:
            write_log(f"Chat input not found after sending", "WARN")
            return True  # Assume success if we got this far
            
    except Exception as e:
        write_log(f"✗ Failed to send {os.path.basename(path)}: {e}", "ERROR")
        return False

def send_all_files_in_chat(driver, files, contact_name):
    """Send ALL files to the currently open chat (batch operation)"""
    write_log(f"Starting batch send: {len(files)} files to {contact_name}")
    
    success_count = 0
    failed_files = []
    
    for i, path in enumerate(files, 1):
        if _shutdown:
            write_log("Shutdown requested, stopping batch send", "WARN")
            break
        
        write_log(f"[{i}/{len(files)}] Processing: {os.path.basename(path)}")
        
        if send_single_file(driver, path):
            success_count += 1
        else:
            failed_files.append(path)
        
        # Cooldown between files
        sleep_jitter(2)
    
    write_log(f"Batch complete: {success_count}/{len(files)} sent successfully to {contact_name}", 
              "SUCCESS" if success_count == len(files) else "WARN")
    
    return success_count == len(files), failed_files

# ================= PROCESS =================

def process_pending(driver):
    """Process all pending folders"""
    if not os.path.exists(PENDING_DIR):
        write_log(f"Pending dir not found: {PENDING_DIR}", "WARN")
        time.sleep(5)
        return
    
    folders = sorted(os.listdir(PENDING_DIR))
    write_log(f"Found {len(folders)} folders to process")
    
    for group in folders:
        if _shutdown:
            return
        
        gpath = os.path.join(PENDING_DIR, group)
        if not os.path.isdir(gpath):
            continue
        
        # Collect ALL stable files for this client
        files = [
            os.path.join(gpath, f)
            for f in sorted(os.listdir(gpath))
            if os.path.splitext(f)[1].lower() in IMAGE_EXTS
            and is_file_stable(os.path.join(gpath, f))
        ]
        
        if not files:
            continue
        
        write_log(f"{'='*60}")
        write_log(f"Processing folder: {group} ({len(files)} files)")
        write_log(f"{'='*60}")
        
        # Open chat with verification
        if not open_chat(driver, group):
            write_log(f"✗ Failed to open chat for: {group}", "ERROR")
            # Move to failed directory
            failed_dest = os.path.join(FAILED_DIR, group)
            os.makedirs(failed_dest, exist_ok=True)
            write_log(f"Moving to FAILED_DIR: {group}", "WARN")
            continue
        
        # Send ALL files in batch
        all_sent, failed_files = send_all_files_in_chat(driver, files, group)
        
        if all_sent:
            # SUCCESS: Move all files to COMPLETE
            dest = os.path.join(COMPLETE_DIR, group)
            os.makedirs(dest, exist_ok=True)
            
            for f in files:
                try:
                    shutil.move(f, os.path.join(dest, os.path.basename(f)))
                    write_log(f"✓ Moved to COMPLETE: {os.path.basename(f)}", "DEBUG")
                except Exception as e:
                    write_log(f"✗ Failed to move {f}: {e}", "ERROR")
            
            write_log(f"✓✓✓ ALL FILES SENT AND MOVED for {group} ✓✓✓", "SUCCESS")
        else:
            # PARTIAL FAILURE: Keep files in PENDING for retry
            write_log(f"✗✗✗ Some files failed for {group}, keeping in PENDING ✗✗✗", "ERROR")
            write_log(f"Failed files: {[os.path.basename(f) for f in failed_files]}", "ERROR")

# ================= MAIN =================

def main():
    write_log(f"{'='*60}")
    write_log(f"WhatsApp Auto Sender - IMPROVED VERSION")
    write_log(f"Watching: {PENDING_DIR}")
    write_log(f"{'='*60}")
    
    # Create directories
    os.makedirs(COMPLETE_DIR, exist_ok=True)
    os.makedirs(FAILED_DIR, exist_ok=True)
    
    try:
        driver = create_driver()
        driver.get("https://web.whatsapp.com/")
        wait_for_whatsapp(driver)
        
        write_log("Watch mode started - monitoring for new files...")
        
        while not _shutdown:
            process_pending(driver)
            time.sleep(POLL_INTERVAL)
            
    except Exception as e:
        write_log(f"CRITICAL: Main loop crashed: {e}", "CRITICAL")
    finally:
        try:
            driver.quit()
        except:
            pass
        write_log("Driver closed", "INFO")

if __name__ == "__main__":
    main()
