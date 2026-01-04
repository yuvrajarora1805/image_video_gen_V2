@echo off
cd /d %~dp0
echo [%DATE% %TIME%] Launching workers... >> worker_launcher.log
start "" /B "C:\Users\yuvra\AppData\Local\Programs\Python\Python313\python.exe" run_workers.py >> worker_launcher.log 2>&1
echo [%DATE% %TIME%] Workers finished. >> worker_launcher.log
