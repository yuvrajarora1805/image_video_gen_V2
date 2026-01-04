# Automation Plan: Auto-Start/Stop Workers

## Objective
Automate queue workers to start on demand and stop when finished.

## Changes Required

### 1. Modify `run_workers.py`
- Update command to use `--stop-when-empty`.
- Update logic to **NOT** restart workers if they exit successfully (return code 0).
- Script should exit when all workers are done.

### 2. Modify `VideoGenerationController.php`
- Add code to launch `run_workers.py` in the background after dispatching jobs.
- Use `pclose(popen("start /B python ..."))` or similar Windows-compatible background execution.

## Flow
1. **User clicks Execute** on web UI.
2. **Controller** dispatches 10 videos to DB queue.
3. **Controller** executes `python run_workers.py`.
4. **Python Script** launches 3 workers with `--stop-when-empty`.
5. **Workers** process all jobs in parallel.
6. **Workers** exit automatically when queue is empty.
7. **Python Script** detects completion and exits.
8. **System** is idle and clean.
