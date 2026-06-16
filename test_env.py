import os
import sys
import time
import subprocess

def test_libs():
    libs = ["requests", "pyautogui", "pyperclip", "undetected_chromedriver", "selenium"]
    print("-" * 30)
    print("1. LIBRARY CHECK")
    print("-" * 30)
    for lib in libs:
        try:
            mod = __import__(lib)
            version = getattr(mod, "__version__", "unknown")
            print(f"[OK] {lib:<22} (v{version})")
        except ImportError:
            print(f"[FAIL] {lib:<22} (NOT INSTALLED)")
            print(f"       Action: Run 'pip install {lib}'")

def test_gui():
    print("\n" + "-" * 30)
    print("2. GUI & INPUT CHECK")
    print("-" * 30)
    try:
        import pyautogui
        import pyperclip
        
        # Screen
        size = pyautogui.size()
        print(f"[OK] Screen Size:        {size[0]}x{size[1]}")
        
        # Mouse
        pos = pyautogui.position()
        print(f"[OK] Mouse Position:    {pos}")
        
        # Clipboard
        test_str = "Antigravity Test " + str(time.time())
        pyperclip.copy(test_str)
        time.sleep(0.2)
        if pyperclip.paste() == test_str:
            print("[OK] Clipboard:          WORKING")
        else:
            print("[FAIL] Clipboard:        MISMATCH (Check if something else is using clipboard)")
            
    except Exception as e:
        print(f"[FAIL] GUI check error: {e}")

def test_browser():
    print("\n" + "-" * 30)
    print("3. CHROME & DRIVER CHECK")
    print("-" * 30)
    
    CHROME_INSTALL_DIR = r"C:\temp\chrome-145"
    CHROME_BINARY_PATH = os.path.join(CHROME_INSTALL_DIR, "chrome-win64", "chrome.exe")
    
    if os.path.exists(CHROME_BINARY_PATH):
        print(f"[OK] Local Chrome:        FOUND at {CHROME_BINARY_PATH}")
        # Try to get version
        try:
            ver = subprocess.check_output([CHROME_BINARY_PATH, "--version"]).decode().strip()
            print(f"     Actual Binary:      {ver}")
        except: pass
    else:
        print(f"[WARN] Local Chrome:      NOT FOUND (Script will try system default)")

    try:
        import undetected_chromedriver as uc
        from selenium.webdriver.common.by import By
        from selenium.webdriver.common.keys import Keys
        print("[INFO] Libraries loaded. Now attempting to launch browser...")
        
        opts = uc.ChromeOptions()
        # Use a separate test profile to avoid "profile in use" errors
        test_profile = rf"C:\temp\test-chrome-profile-{int(time.time())}" # Unique profile
        opts.add_argument(f"--user-data-dir={test_profile}")
        opts.add_argument("--window-size=1200,800")
        
        print(f"[DEBUG] Profile folder: {test_profile}")
        print(f"[DEBUG] Binary path: {CHROME_BINARY_PATH}")
        print("[DEBUG] Calling uc.Chrome(version_main=145)... Please wait up to 30s")
        
        # Attempt to launch
        driver = uc.Chrome(
            options=opts, 
            version_main=145, 
            browser_executable_path=CHROME_BINARY_PATH if os.path.exists(CHROME_BINARY_PATH) else None,
            use_subprocess=True # Often helps with hangs
        )
        
        print("[DEBUG] uc.Chrome initialized. Setting 15s page load timeout...")
        driver.set_page_load_timeout(15)
        
        print("[DEBUG] Navigating to https://www.google.com ...")
        try:
            driver.get("https://www.google.com")
            print(f"[OK] Browser Comms:      WORKING (Title: {driver.title})")
        except Exception as nav_e:
            print(f"[FAIL] Navigation Error: {nav_e}")
            print(f"       Current URL:      {driver.current_url}")
        
        time.sleep(1)
        # Test finding a simple element
        print("[DEBUG] Looking for 'q' (search box) element...")
        search_box = driver.find_elements(By.NAME, "q")
        if search_box:
            print("[OK] Element Discovery:  WORKING")
        else:
            print("[FAIL] Element Discovery: Could not find 'q' (Google search box)")
        
        print("[DEBUG] Closing browser...")
        driver.quit()
        print("[OK] Browser Shutdown:   CLEAN")
        
    except Exception as e:
        print(f"[FAIL] Browser Error: {e}")
        import traceback
        print("\n--- Detailed Error ---")
        print(traceback.format_exc())

if __name__ == "__main__":
    print("=" * 40)
    print("   ENVIRONMENT DIAGNOSTIC SCRIPT")
    print("=" * 40)
    test_libs()
    test_gui()
    test_browser()
    print("\n" + "=" * 40)
    print("Test Complete.")
    print("=" * 40)
