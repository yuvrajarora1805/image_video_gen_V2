import subprocess
import time
import sys
import os
import signal

# Load PHP path from .env file
def load_env():
    """Load environment variables from .env file"""
    env_path = os.path.join(os.path.dirname(__file__), '.env')
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
    
    return php_path

# Configuration
NUM_WORKERS = 4
PHP_PATH = load_env()
# --stop-when-empty ensures the worker exits automatically when queue is empty
QUEUE_CMD = [PHP_PATH, "artisan", "queue:work", "--queue=video_cpu", "--sleep=1", "--tries=2", "--stop-when-empty"]
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))

# Log startup immediately for user verification
with open(os.path.join(PROJECT_DIR, "workers.log"), "a") as f:
    f.write(f"\n[STARTED] Workers launched at {time.ctime()}\n")

workers = []

def signal_handler(sig, frame):
    print("\n🛑 Stopping all workers...")
    for p in workers:
        if p.poll() is None:  # If still running
            p.terminate()
    sys.exit(0)

def start_workers():
    print(f"🚀 Starting {NUM_WORKERS} Auto-Stopping Workers...")
    print(f"📂 Working Directory: {PROJECT_DIR}")
    print("-" * 50)
    
    for i in range(NUM_WORKERS):
        try:
            p = subprocess.Popen(
                QUEUE_CMD,
                cwd=PROJECT_DIR,
                creationflags=subprocess.CREATE_NEW_CONSOLE if sys.platform == 'win32' else 0
            )
            workers.append(p)
            print(f"✅ Worker {i+1} started (PID: {p.pid})")
        except Exception as e:
            print(f"❌ Failed to start worker {i+1}: {e}")

    print("-" * 50)
    print("Workers will exit automatically when queue is empty.")
    print("Keeping this manager process alive until all workers are done...")

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    
    start_workers()
    
    try:
        while True:
            # Check if all workers have finished
            all_done = True
            for i, p in enumerate(workers):
                ret = p.poll()
                if ret is None:
                    # Worker still running
                    all_done = False
                elif ret != 0:
                    # Worker failed (non-zero exit code), consider restarting?
                    # But for --stop-when-empty, usually exit code 0 means done.
                    # Error code usually means crash.
                    # For simplicity, let's not auto-restart to avoid infinite crash loops, 
                    # unless user wants resilience. Given user wants "auto stop", we accept exit.
                    pass
            
            if all_done:
                print("\n✅ All workers have finished. Exiting manager.")
                break
                
            time.sleep(1)
            
    except KeyboardInterrupt:
        signal_handler(None, None)
