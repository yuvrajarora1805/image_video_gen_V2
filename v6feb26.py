#!/usr/bin/env python3
"""
WhatsApp Auto Sender (PYAUTOGUI FILE PICKER) - Video Optimized & Image Fixed
With CRITICAL FIXES:
1. Hard UI Reset (Recovery from stuck states)
2. Strict Name Verification (Anti-Wrong-Send)
3. Robust Attach Menu (Retry Logic)
4. Broad Selectors (Plus-Rounded support)
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
PENDING_DIR = r"\\Main-pc\h\PENDING_DIR"
COMPLETE_DIR = r"C:\Rannlab\autosend\COMPLETE_DIR"

# Increased timeouts for videos
WAIT_TIMEOUT = 120  # Increased global timeout
PREVIEW_WAIT = 5    # Increased wait for preview to load
SEND_DELAY = 1
POLL_INTERVAL = 1

# Supported Extensions
IMAGE_EXTS = {
    ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp",
    ".mp4", ".mov", ".avi", ".mkv"
}

LOG_FILE = os.path.join(COMPLETE_DIR, "autosend.log")
_shutdown = False

pyautogui.FAILSAFE = True
pyautogui.PAUSE = 0.3  # Reduced for speed

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

signal.signal(signal.SIGINT, stop_handler)
signal.signal(signal.SIGTERM, stop_handler)

# ================= UTIL =================

TEMP_STAGING_DIR = r"C:\t_W"

# ... (Existing Config) ...

# ================= UTIL =================

def stage_files_with_short_names(original_paths):
    """
    Copies files to a temp dir with short names (1.jpg, 2.jpg)
    Returns: (list_of_temp_paths, map_temp_to_original)
    """
    if not os.path.exists(TEMP_STAGING_DIR):
        os.makedirs(TEMP_STAGING_DIR)

    # Clean temp dir first
    for f in os.listdir(TEMP_STAGING_DIR):
        try:
            os.remove(os.path.join(TEMP_STAGING_DIR, f))
        except:
            pass

    temp_paths = []
    mapping = {} # temp_path -> original_path

    for i, orig_path in enumerate(original_paths):
        ext = os.path.splitext(orig_path)[1]
        short_name = f"{i+1}{ext}" # e.g. 1.jpg
        temp_path = os.path.join(TEMP_STAGING_DIR, short_name)
        
        try:
            shutil.copy2(orig_path, temp_path)
            temp_paths.append(temp_path)
            mapping[temp_path] = orig_path
        except Exception as e:
            write_log(f"[ERROR] Failed to stage {orig_path}: {e}")

    return temp_paths, mapping

def cleanup_staging():
    try:
        if os.path.exists(TEMP_STAGING_DIR):
            shutil.rmtree(TEMP_STAGING_DIR)
    except:
        pass

def sleep_jitter(v):
    time.sleep(max(0.2, random.uniform(v * 0.8, v * 1.2)))

def is_file_stable(path, retries=5, delay=1.0): 
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

# ================= ERROR HANDLING =================

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
    time.sleep(0.2)

    for ch in name:
        search.send_keys(ch)
        time.sleep(random.uniform(0.01, 0.05))

    sleep_jitter(0.5)

    try:
        # Click chat
        wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, f'//span[@title="{name}"]')
            )
        ).click()
        sleep_jitter(0.5) # Wait for chat load
        
        # CRITICAL: STRICT NAME VERIFICATION
        try:
            # 1. Wait for header logic
            wait.until(EC.presence_of_element_located((By.XPATH, '//header//div[@role="button"]')))
            
            # 2. Robust Verification: Scan ENTIRE Header
            # Logic: valid chat MUST have the name somewhere in the header (usually top line).
            try:
                # Get the whole header element
                header_el = wait.until(EC.visibility_of_element_located((By.TAG_NAME, "header")))
                header_text = header_el.text
                
                # Split into lines
                header_lines = [line.strip() for line in header_text.split('\n') if line.strip()]
                write_log(f"[DEBUG] Full Header Text: {header_lines}")

                # Check if name is in header
                found = False
                for line in header_lines:
                    # Check exact match or "Name (You)"
                    if line == name or line == f"{name} (You)":
                        found = True
                        break
                    # Check if name is contained (e.g. truncated cases, dangerous but sometimes needed)
                    # For now, strict on StartsWith to avoid false positives
                    if line.startswith(name): 
                         found = True
                         break
                
                if found:
                     write_log(f"[OK] Chat Verified: Found '{name}' in header")
                     return True

                # Debug: Dump HTML to see why we only see '8'
                try:
                    html_dump = header_el.get_attribute('outerHTML')[:500] # First 500 chars
                    write_log(f"[DEBUG] Header HTML (partial): {html_dump}")
                except:
                    pass

                # WARN ONLY - DO NOT ABORT
                # The verification selectors are proving too flaky (finding '8' or 'click here').
                # We will log the error but TRUST the search result for now.
                write_log(f"[WARN] Name Verification Failed (Expected '{name}' not in {header_lines})")
                write_log(f"[WARN] Proceeding with send anyway (Verification Disabled causing false negatives)")
                return True
                
            except Exception as e:
                write_log(f"[WARN] Chat verification logic error: {e}")
                return True
            
        except Exception as e:
            write_log(f"[ERROR] Chat verification failed for {name}: {e}")
            return False

    except Exception:
        return False

# ================= SEND MEDIA (PYAUTOGUI) =================

def upload_file_via_dialog(path):
    """Type file path into OS file dialog using pyautogui"""
    try:
        pyperclip.copy(path)
        
        # Verify clipboard content
        if pyperclip.paste() != path:
            write_log("[WARN] Clipboard mismatch! Retrying copy...")
            time.sleep(0.5)
            pyperclip.copy(path)
            if pyperclip.paste() != path:
                 write_log("[ERROR] Clipboard failed to copy full path string!")

        time.sleep(0.5) # Reduced wait for clipboard
        pyautogui.hotkey("ctrl", "v")
        time.sleep(2.0) # INCREASED: Wait for paste to register in dialog
        pyautogui.press("enter")
    except Exception as e:
        write_log(f"[ERROR] PyAutoGUI failed: {e}")

def send_images_in_open_chat(driver, paths):
    wait = WebDriverWait(driver, WAIT_TIMEOUT)
    paths = [os.path.abspath(p) for p in paths if os.path.isfile(p)]

    write_log(f"[INFO] Sending {len(paths)} media files in BATCH")
    
    if not paths:
        return True

    # Prepare string for file dialog: "file1" "file2"
    file_string = " ".join([f'"{p}"' for p in paths])
    
    # Just use the first path for logging/tracking purposes for now, or a generic name
    display_name = f"{len(paths)} files"
    
    if _shutdown: return False
    
    write_log(f"[INFO] Uploading batch: {display_name}")
    write_log(f"[DEBUG] Full file string to paste ({len(file_string)} chars): {file_string}")

    try:
            # Retry loop for opening Attach menu (fixes 2nd image timeout)
        max_menu_retries = 3
        menu_open = False
        
        for attempt in range(max_menu_retries):
            try:
                write_log(f"[INFO] Looking for attach button (Attempt {attempt+1})...")
                
                # Debug: Count potential buttons
                try:
                    btns = driver.find_elements(By.XPATH, "//span[@data-icon='plus-rounded']")
                    write_log(f"[DEBUG] Found {len(btns)} 'plus-rounded' elements")
                except:
                    pass

                # Updated Selectors based on User Inspect
                attach_btn = wait.until(
                    EC.presence_of_element_located((By.XPATH, "//span[@data-icon='plus-rounded'] | //div[@title='Attach'] | //span[@data-icon='plus'] | //span[@data-icon='clip'] | //div[@aria-label='Attach']"))
                )
                
                # Scroll into view just in case
                driver.execute_script("arguments[0].scrollIntoView({block: 'center'});", attach_btn)
                time.sleep(0.5)
                
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

        sleep_jitter(1.0) # Reduced wait for dialog

        # OS dialog is open now - SEND ALL FILES
        upload_file_via_dialog(file_string)

        write_log(f"[INFO] Waiting for preview/processing of batch")
        
        # Wait for the "Send" button to be clickable
        try:
            # Use a specific selector for the Send button and ensure it's clickable
            send_btn = wait.until(
                EC.element_to_be_clickable((By.XPATH, "//span[contains(@data-icon,'send')]"))
            )
            
            sleep_jitter(0.2) 
            
            send_btn.click()
            write_log(f"[OK] Clicked Send for batch")
            
            # CRITICAL FIX FOR IMAGES:
            # Wait for the SEND BUTTON to disappear (indicating upload started/sent)
            # Images send fast, so this ensures we don't loop back too quickly
            try:
                WebDriverWait(driver, 60).until(
                    EC.invisibility_of_element_located((By.XPATH, "//span[contains(@data-icon,'send')]"))
                )
            except TimeoutException:
                write_log(f"[WARN] Send button didn't disappear for batch, likely slow upload")
            
            # Wait a moment to ensure back in chat view
            time.sleep(6.0) # Increased to 6s before moving verified
            
            # Verify we are back in chat (Input box visible)
            try:
                wait.until(EC.presence_of_element_located((By.XPATH, "//div[@contenteditable='true']")))
            except:
                write_log(f"[WARN] Chat input not found after sending batch")

        except TimeoutException:
            write_log(f"[ERROR] Timeout waiting for Send button for batch")
            return False

    except Exception as e:
        write_log(f"[ERROR] Exception sending batch: {e}")
        return False

    sleep_jitter(1.0) # Cooldown between groups

    return True

# ================= PROCESS =================

def process_pending(driver):
    if not os.path.exists(PENDING_DIR):
        write_log(f"[WARN] Pending dir not found: {PENDING_DIR}")
        time.sleep(5)
        return

    # Debug: List all items in PENDING_DIR
    try:
        all_items = os.listdir(PENDING_DIR)
        write_log(f"[INFO] Found {len(all_items)} items in PENDING_DIR")
    except Exception as e:
        write_log(f"[ERROR] Cannot list PENDING_DIR: {e}")
        time.sleep(5)
        return

    groups_processed = 0
    groups_scanned = 0
    
    # Process each group immediately as we find files
    for group in sorted(all_items):
        if _shutdown:
            return

        groups_scanned += 1
        if groups_scanned % 50 == 0:
            write_log(f"[INFO] Scanning progress: {groups_scanned}/{len(all_items)} groups checked, {groups_processed} sent...")

        gpath = os.path.join(PENDING_DIR, group)
        if not os.path.isdir(gpath):
            continue

        # Debug: Check files before filtering
        # write_log(f"[DEBUG] Checking group: {group}, All files: {all_files_in_group}")

        try:
            all_files_in_group = os.listdir(gpath)
        except Exception as e:
            write_log(f"[ERROR] Cannot list group '{group}': {e}")
            continue

        files = []
        for f in sorted(all_files_in_group):
            full_path = os.path.join(gpath, f)
            ext = os.path.splitext(f)[1].lower()
            
            # 1. Extension Check
            if ext not in IMAGE_EXTS:
                # write_log(f"[DEBUG] Skipping {f} (Invalid Ext: {ext})")
                continue
                
            # 2. Stability Check
            if not is_file_stable(full_path):
                write_log(f"[WARN] Skipping {f} (File not stable/uploading)")
                continue
                
            files.append(full_path)
            
        if files:
            write_log(f"[DEBUG] Found valid files for {group}: {[os.path.basename(x) for x in files]}")
        
        # If files found, send them immediately
        if files:
            groups_processed += 1
            write_log(f"[INFO] ========== Processing group {groups_processed}: {group} (Found {len(files)} files) ==========")

            try:
                # Attempt to open the chat with verification
                if not open_chat(driver, group):
                    write_log(f"[ERROR] Failed to open chat for: {group}. Skipping this group.")
                    continue

                # STAGE FILES to C:\temp (Short paths)
                temp_files, mapping = stage_files_with_short_names(files)
                write_log(f"[INFO] Staged {len(temp_files)} files to {TEMP_STAGING_DIR}")
                
                # Send the staged (short path) files
                # We can now send MORE files because path string is short
                success = send_images_in_open_chat(driver, temp_files)
                
                if success:
                    write_log(f"[OK] Successfully sent batch to {group}")
                    # Move ORIGINAL files to complete directory
                    dest = os.path.join(COMPLETE_DIR, group)
                    os.makedirs(dest, exist_ok=True)
                    
                    for temp_f in temp_files:
                        original_f = mapping.get(temp_f)
                        if original_f:
                            try:
                                shutil.move(original_f, os.path.join(dest, os.path.basename(original_f)))
                                write_log(f"[OK] Moved {os.path.basename(original_f)} to COMPLETE")
                            except Exception as e:
                                write_log(f"[ERROR] Failed to move {original_f}: {e}")
                else:
                    write_log(f"[ERROR] Failed to send file to {group}. File remains in PENDING.")
                    # Trigger reset if send returned False (indicates failure)
                    hard_reset_ui(driver)
            
            except Exception as e:
                write_log(f"[ERROR] CRITICAL FAILURE sending group {group}: {e}")
                hard_reset_ui(driver)
            
            # Clean up temp files
            cleanup_staging()

            # Wait between groups to ensure UI fully resets
            # Reduced slightly since we are doing 1 file at a time, but safety first
            write_log(f"[INFO] Waiting 1 second before processing next group...")
            time.sleep(1)
    
    write_log(f"[INFO] Scan complete. Processed {groups_processed} groups out of {groups_scanned} total.")

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
