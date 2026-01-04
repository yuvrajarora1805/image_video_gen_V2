@echo off
title Laravel Queue Manager
echo Starting 3 Video Processing Workers...
echo.

:: Worker 1
start "Video Worker 1" /MIN php artisan queue:work --queue=video_cpu --sleep=1 --tries=2

:: Worker 2
start "Video Worker 2" /MIN php artisan queue:work --queue=video_cpu --sleep=1 --tries=2

:: Worker 3
start "Video Worker 3" /MIN php artisan queue:work --queue=video_cpu --sleep=1 --tries=2

echo ✅ 3 Workers Started in background windows!
echo DO NOT close the minimized windows.
echo.
pause
