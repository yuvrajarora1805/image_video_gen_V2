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
# Persistent workers - will keep running until manually stopped
QUEUE_CMD = [PHP_PATH, "artisan", "queue:work", "--queue=video_cpu", "--sleep=3", "--tries=2"]
PROJECT_DIR = os.path.dirname(os.path.abspath(__file__))

workers = []

def signal_handler(sig, frame):
    print("\n🛑 Stopping all workers...")
    for p in workers:
        if p.poll() is None:
            p.terminate()
    sys.exit(0)

def start_workers():
    print(f"🚀 Starting {NUM_WORKERS} Persistent Workers...")
    print(f"📂 Working Directory: {PROJECT_DIR}")
    print("⚠️  Workers will keep running until manually stopped (Ctrl+C)")
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
    print("✅ All workers started. Press Ctrl+C to stop.")

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    
    start_workers()
    
    try:
        while True:
            # Monitor workers and restart if they crash
            for i, p in enumerate(workers):
                ret = p.poll()
                if ret is not None and ret != 0:
                    print(f"⚠️  Worker {i+1} crashed (exit code {ret}). Restarting...")
                    new_p = subprocess.Popen(
                        QUEUE_CMD,
                        cwd=PROJECT_DIR,
                        creationflags=subprocess.CREATE_NEW_CONSOLE if sys.platform == 'win32' else 0
                    )
                    workers[i] = new_p
                    print(f"✅ Worker {i+1} restarted (PID: {new_p.pid})")
            
            time.sleep(2)
            
    except KeyboardInterrupt:
        signal_handler(None, None)
