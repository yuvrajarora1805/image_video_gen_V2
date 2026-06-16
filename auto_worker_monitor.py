#!/usr/bin/env python3
"""
Auto-start workers when queue has jobs
Checks every 30 seconds and starts workers if needed
"""

import subprocess
import time
import os
import sys

# Load configuration from .env file
def load_env():
    """Load environment variables from .env file"""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    env_path = os.path.join(script_dir, '.env')
    php_path = 'php'  # Default fallback
    
    if os.path.exists(env_path):
        try:
            with open(env_path, 'r') as f:
                for line in f:
                    line = line.strip()
                    if line.startswith('PHP_PATH='):
                        php_path = line.split('=', 1)[1].strip()
                        break
        except Exception as e:
            print(f"⚠️  Warning: Could not read .env file: {e}")
    
    return script_dir, php_path

PROJECT_DIR, PHP_PATH = load_env()
NUM_WORKERS = 4

def count_running_workers():
    """Count how many queue workers are currently running"""
    try:
        if sys.platform == 'win32':
            result = subprocess.run(
                ['tasklist', '/FI', 'IMAGENAME eq php.exe', '/FO', 'CSV'],
                capture_output=True,
                text=True
            )
            # Count lines containing "artisan queue:work"
            count = 0
            for line in result.stdout.split('\n'):
                if 'php.exe' in line.lower():
                    count += 1
            return count
        else:
            result = subprocess.run(
                ['ps', 'aux'],
                capture_output=True,
                text=True
            )
            count = result.stdout.count('queue:work')
            return count
    except:
        return 0

def check_queue_size():
    """Check if there are jobs in the queue"""
    try:
        result = subprocess.run(
            [PHP_PATH, 'artisan', 'queue:size', 'video_cpu'],
            cwd=PROJECT_DIR,
            capture_output=True,
            text=True
        )
        size = int(result.stdout.strip())
        return size
    except:
        return 0

def start_workers():
    """Start worker processes"""
    print(f"🚀 Starting {NUM_WORKERS} workers...")
    subprocess.Popen(
        ['python', 'run_workers_persistent.py'],
        cwd=PROJECT_DIR,
        creationflags=subprocess.CREATE_NEW_CONSOLE if sys.platform == 'win32' else 0
    )
    print("✅ Workers started")

def main():
    print("👁️  Auto-Worker Monitor Started")
    print("Checking queue every 30 seconds...")
    print("Press Ctrl+C to stop")
    print("-" * 50)
    
    while True:
        try:
            queue_size = check_queue_size()
            worker_count = count_running_workers()
            
            print(f"📊 Queue: {queue_size} jobs | Workers: {worker_count}")
            
            # Start workers if queue has jobs but no workers running
            if queue_size > 0 and worker_count == 0:
                print("⚠️  Jobs in queue but no workers running!")
                start_workers()
            
            time.sleep(30)  # Check every 30 seconds
            
        except KeyboardInterrupt:
            print("\n👋 Stopping monitor...")
            break
        except Exception as e:
            print(f"❌ Error: {e}")
            time.sleep(30)

if __name__ == "__main__":
    main()
