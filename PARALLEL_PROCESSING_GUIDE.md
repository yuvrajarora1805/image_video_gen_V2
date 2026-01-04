# PARALLEL VIDEO PROCESSING GUIDE

## Overview
Process multiple videos simultaneously to dramatically speed up bulk video generation.

## How It Works

### Single Video (Current):
- Generates 1 video at a time
- Uses 10 CPU threads per video
- Time: ~10-20 seconds per video

### Parallel Processing (New):
- Generates 2-4 videos simultaneously
- Each uses 10 threads
- Time: ~10-20 seconds for 2-4 videos (same time!)
- **2-4x faster for bulk operations!**

## Usage

### Method 1: Using JSON Task File

1. Create a tasks file (`tasks.json`):
```json
[
  {
    "bg_video": "D:/xamp/htdocs/imgen/public_html/public_html/public/videos/background_video/bg1.mp4",
    "template": "D:/xamp/htdocs/imgen/public_html/public_html/public/img/user_template/template1.png",
    "output": "D:/xamp/htdocs/imgen/public_html/public_html/public/videos/generated_video/output1.mp4",
    "animation": "fade-in",
    "duration": 2
  },
  {
    "bg_video": "D:/xamp/htdocs/imgen/public_html/public_html/public/videos/background_video/bg2.mp4",
    "template": "D:/xamp/htdocs/imgen/public_html/public_html/public/img/user_template/template2.png",
    "output": "D:/xamp/htdocs/imgen/public_html/public_html/public/videos/generated_video/output2.mp4",
    "animation": "slide-in",
    "duration": 2
  }
]
```

2. Run parallel generation:
```bash
python parallel_video_generator.py tasks.json 3
```
(3 = number of parallel workers)

### Method 2: From Laravel (Recommended)

The system will automatically use parallel processing when generating multiple videos.

## Performance Recommendations

### For 12 CPU Cores:
- **2-3 parallel workers** = Optimal balance
- Each worker uses 10 threads
- Total: 20-30 threads (leaves 2 cores for system)

### Worker Count Guidelines:
- **2 workers**: Safest, good performance
- **3 workers**: Best performance for 12 cores
- **4 workers**: Maximum (may slow down system)

## Example Performance

### Sequential (Old):
- 10 videos × 15 seconds = **150 seconds (2.5 minutes)**

### Parallel with 3 workers (New):
- 10 videos ÷ 3 workers × 15 seconds = **50 seconds**
- **3x faster!**

## Monitoring

Watch CPU usage in Task Manager:
- Should see 80-90% CPU usage during parallel generation
- All cores should be active
- Memory usage: ~500MB per worker

## Troubleshooting

**Videos fail randomly:**
- Reduce worker count (use 2 instead of 3)
- System might be running out of memory

**System becomes slow:**
- Reduce worker count
- Close other applications

**No speed improvement:**
- Check if disk I/O is bottleneck (use SSD)
- Verify CPU usage is high (80%+)
