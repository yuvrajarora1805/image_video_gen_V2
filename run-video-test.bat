@echo off
echo Running video generation test...
php test-video-generation.php > video-test-log.txt 2>&1
echo.
echo Test complete! Check video-test-log.txt for results
type video-test-log.txt
