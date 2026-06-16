@echo off
REM Video Queue Workers - Auto-Start Script
REM This script starts persistent queue workers

cd /d D:\xamp\htdocs\imgen\public_html\public_html
echo Starting Video Queue Workers...
python run_workers_persistent.py
