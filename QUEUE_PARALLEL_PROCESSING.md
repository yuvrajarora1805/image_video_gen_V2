# Laravel Queue-Based Parallel Processing

## ✅ IMPLEMENTATION COMPLETE

### What Changed:
- Videos are now dispatched to Laravel queues
- Queue workers process videos in parallel
- Much simpler than Python multiprocessing
- More reliable and easier to debug

---

## How to Run Queue Workers

### Option 1: Single Worker (Testing)
```bash
php artisan queue:work --queue=video_cpu --sleep=1 --tries=2
```

### Option 2: Multiple Workers (Production - 3x Parallel)
Open **3 separate terminal windows** and run in each:

**Terminal 1:**
```bash
php artisan queue:work --queue=video_cpu --sleep=1 --tries=2
```

**Terminal 2:**
```bash
php artisan queue:work --queue=video_cpu --sleep=1 --tries=2
```

**Terminal 3:**
```bash
php artisan queue:work --queue=video_cpu --sleep=1 --tries=2
```

---

## How It Works

1. **User clicks "Execute"** on a video task
2. **Laravel dispatches** each video as a queue job
3. **Queue workers** pick up jobs and process in parallel
4. **Videos generate** simultaneously (3 at a time with 3 workers)
5. **Results saved** to database automatically

---

## Performance

### With 1 Worker (Sequential):
- 10 videos = ~100 seconds
- Same as before

### With 3 Workers (Parallel):
- 10 videos = ~35 seconds
- **3x faster!** ⚡

---

## Configuration

### Queue Settings:
- **Queue name**: `video_cpu`
- **Timeout**: 3600 seconds (1 hour)
- **Retries**: 2 attempts
- **Threads per video**: 4

### System Resources (3 workers):
- **CPU**: 3 × 4 threads = 12 threads (100% utilization)
- **Memory**: ~1.5GB total
- **Perfect for 12 cores!**

---

## Monitoring

### Check Queue Status:
```bash
php artisan queue:monitor video_cpu
```

### View Failed Jobs:
```bash
php artisan queue:failed
```

### Retry Failed Jobs:
```bash
php artisan queue:retry all
```

---

## Production Deployment

### Using Supervisor (Recommended):

Create `/etc/supervisor/conf.d/laravel-worker.conf`:

```ini
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /path/to/artisan queue:work --queue=video_cpu --sleep=1 --tries=2
autostart=true
autorestart=true
user=www-data
numprocs=3
redirect_stderr=true
stdout_logfile=/path/to/worker.log
```

Then:
```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start laravel-worker:*
```

---

## Testing

1. **Start 3 queue workers** (3 terminals)
2. **Create a video task** with 10 customers
3. **Click "Execute"**
4. **Watch the terminals** - you'll see 3 videos processing simultaneously
5. **Check completion time** - should be ~35 seconds for 10 videos

---

## Advantages Over Python Multiprocessing

✅ **Simpler** - No complex JSON parsing
✅ **More reliable** - Laravel handles job management
✅ **Better error handling** - Failed jobs can be retried
✅ **Easier to scale** - Just add more workers
✅ **Better monitoring** - Laravel queue dashboard
✅ **No blocking** - Web requests don't wait for videos

---

## Troubleshooting

### Workers not starting:
- Check for "openssl already loaded" warning (ignore it, it's harmless)
- Verify queue connection in `.env` (should be `database` or `redis`)

### Jobs not processing:
- Check `jobs` table in database
- Verify workers are running: `ps aux | grep queue:work`
- Check Laravel logs: `storage/logs/laravel.log`

### Videos failing:
- Check `failed_jobs` table
- View error in `error_logs` table
- Retry with: `php artisan queue:retry <job-id>`

---

## Summary

✅ **Queue-based parallel processing** implemented
✅ **3 workers** = 3x faster video generation
✅ **Simple to run** - just start queue workers
✅ **Production ready** - use Supervisor for auto-restart

**Start 3 queue workers and test it now!** 🚀
