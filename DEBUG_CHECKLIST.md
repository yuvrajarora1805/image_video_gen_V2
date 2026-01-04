# Debug Checklist: Slow Loading & Generation Failure

## 1. System State Analysis
- [ ] Check for stuck `php.exe` or `python.exe` processes (is CPU maxed?).
- [ ] Check `worker_launcher.log` for execution timestamps.
- [ ] Check `laravel.log` for PHP errors or timeouts.

## 2. Worker Launch Mechanism
- [ ] Verify if `COM` (WScript.Shell) is enabled in PHP.
- [ ] Logic Check: Is the Controller waiting for the batch file to exit?
    - If `run_workers.py` runs for 5 minutes, and PHP waits, the page loads for 5 minutes.
    - **Hypothesis**: The launch command is NOT effectively detaching.

## 3. Database & Queue
- [ ] Check `jobs` table: Are jobs stacking up?
- [ ] Check `failed_jobs` table.
- [ ] Check `generated_videos`: Are any being created?

## 4. Fix Plan
- [ ] **Force Detach**: Modify launch command to redirect ALL output to NUL/Log and use `start ""`.
- [ ] **Optimize**: Ensure `run_workers.py` is robust.
- [ ] **Feedback**: Ensure UI handles the "queued" state gracefully.
