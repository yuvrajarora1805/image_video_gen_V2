
import os
import subprocess
import sys
import shutil

# Paths (adjust if necessary based on your environment)
BASE_DIR = r"D:\xamp\htdocs\imgen\public_html\public_html"
BG_VIDEO = os.path.join(BASE_DIR, r"public\videos\background_video\bg_video_1767381490.mp4")
TEMPLATE = os.path.join(BASE_DIR, r"public\img\master_template\video_template_1765786550_693fc3b67c005.png")
OUTPUT_DIR = os.path.join(BASE_DIR, "test_output")
GENERATOR_SCRIPT = os.path.join(BASE_DIR, "video_generator.py")

def main():
    print("--- Test Video Generator ---\n")

    # 1. Setup
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)
        print(f"Created output directory: {OUTPUT_DIR}")
    else:
        print(f"Output directory exists: {OUTPUT_DIR}")

    if not os.path.exists(BG_VIDEO):
        print(f"Error: BG Video not found: {BG_VIDEO}")
        return
    if not os.path.exists(TEMPLATE):
        print(f"Error: Template not found: {TEMPLATE}")
        return

    # 2. Test Cases
    # All supported animations found in video_generator.py
    animations = [
        # Original set
        'wipe-in', 
        'fade-in', 
        'slide-in', 
        'zoom-in', 
        'bounce-in', 
        'spiral-in', 
        'none',
        # New set
        'flip-in',
        'flip-vertical',
        'bounce-drop',
        'bounce-slide',
        'elastic-scale'
    ]
    
    for anim in animations:
        print(f"\nTesting Animation: {anim}")
        output_file = os.path.join(OUTPUT_DIR, f"test_{anim}.mp4")
        
        # Clean up previous run
        if os.path.exists(output_file):
            try:
                os.remove(output_file)
            except Exception as e:
                print(f"Warning: Could not remove old file: {e}")

        cmd = [
            sys.executable, 
            GENERATOR_SCRIPT,
            BG_VIDEO,
            TEMPLATE,
            output_file,
            anim
        ]
        
        try:
            result = subprocess.run(cmd, capture_output=True, text=True)
            
            if result.returncode == 0:
                if os.path.exists(output_file):
                    size_mb = os.path.getsize(output_file) / (1024 * 1024)
                    print(f"SUCCESS: {output_file} ({size_mb:.2f} MB)")
                else:
                    print(f"FAILURE: Script returned 0 but file missing.")
            else:
                print(f"FAILURE: Script returned {result.returncode}")
                
        except Exception as e:
            print(f"EXCEPTION: {e}")

    print("\n--- Test Complete ---")

if __name__ == "__main__":
    main()
