# Video Generation System - Quick Setup Guide

## 🚀 Quick Start (5 Steps)

### Step 1: Install Python Dependencies
```bash
pip install moviepy numpy Pillow
```

### Step 2: Verify FFmpeg
```bash
ffmpeg -version
```
If not installed: Download from https://ffmpeg.org/download.html

### Step 3: Run Database Migration
```bash
php artisan migrate
```

### Step 4: Test Python Script
```bash
python video_generator.py testvideo.mp4 public/img/user_template/user_template_1765479311_693b138fee554.png test_output.mp4
```

### Step 5: Create Your First Video Task
1. Go to `/generate-video-form`
2. Upload a background video
3. Select a template (with assigned customers)
4. Click "Create Task"
5. Go to `/generate-videos`
6. Click "Execute" on your task
7. Wait for processing
8. Download videos!

---

## 📋 What You Need to Know

### The System Uses:
- **Background Video**: Your base video (e.g., testvideo.mp4)
- **Customer Templates**: PNG overlays from `public/img/user_template/`
- **Customer Assignments**: From existing `templates_by_user` table
- **Python Script**: Combines video + PNG with animation
- **Wipe-In Effect**: 6.5-second left-to-right reveal with soft edges

### Files Created:
- ✅ `video_generator.py` - Python script for video generation
- ✅ `VideoGenerationController.php` - Updated controller
- ✅ `GeneratedVideo.php` - Model for generated videos
- ✅ Database migration - Adds video support to tables
- ✅ `public/videos/background_video/` - Directory for background videos

### Routes Available:
- `/generate-video-form` - Create video tasks
- `/generate-videos` - View and execute tasks
- `/execute-video-task/{id}` - Run video generation
- `/download-video/{id}` - Download single video
- `/download-task-videos/{taskId}` - Download all as ZIP

---

## 🎯 Quick Test

### Test the Python Script Directly:
```bash
# Navigate to project root
cd d:\xamp\htdocs\imgen\public_html\public_html

# Run the generator
python video_generator.py testvideo.mp4 public/img/user_template/user_template_1765479311_693b138fee554.png output_test.mp4

# Check the output
# File should be created: output_test.mp4
# Should have wipe-in animation effect
```

### Test Through Laravel:
1. **Prepare**:
   - Ensure you have customers in the database
   - Ensure customers are assigned to templates (templates_by_user table)
   - Ensure customer PNG templates exist in `public/img/user_template/`

2. **Create Task**:
   - Visit: `http://localhost/generate-video-form`
   - Upload a background video (MP4 recommended)
   - Select a master template
   - Submit form

3. **Execute Task**:
   - Visit: `http://localhost/generate-videos`
   - Find your task
   - Click "Execute Task"
   - Monitor progress in browser console and Laravel log

4. **Check Results**:
   - Videos in: `public/videos/generated_video/`
   - Thumbnails in: `public/videos/thumbnails/`
   - Database: `generated_videos` table

---

## 🔧 Troubleshooting

### "Python script not found"
```bash
# Check if file exists
ls -l video_generator.py

# Should be in project root
# If not, check VIDEO_GENERATION_CHECKLIST.md for full path
```

### "MoviePy not installed"
```bash
# Install all dependencies
pip install moviepy numpy Pillow
```

### "FFmpeg not found"
```bash
# Windows: Download from https://ffmpeg.org
# Add FFmpeg bin folder to PATH
# Restart terminal/PowerShell
# Verify: ffmpeg -version
```

### "Memory limit exceeded"
Edit `php.ini`:
```ini
memory_limit = 4096M
max_execution_time = 3600
```

### Videos not generating
```bash
# Check Laravel log
tail -f storage/logs/laravel.log

# Look for Python errors
# Common issues:
# - Missing background video file
# - Missing template PNG file
# - FFmpeg not in PATH
# - Python dependencies not installed
```

---

## 📊 What Happens When You Execute a Task

1. **Controller loads task** from database
2. **Fetches background video** path from `before_genration` table
3. **Gets all customers** assigned to the template from `templates_by_user`
4. **For each customer**:
   - Gets their PNG template overlay
   - Calls Python script: `video_generator.py bg.mp4 template.png output.mp4`
   - Python applies wipe-in animation (6.5 seconds)
   - Saves video to `public/videos/generated_video/`
   - Generates thumbnail using FFmpeg
   - Saves record to `generated_videos` table
5. **Marks task complete** with success/failure counts

---

## 🎨 Animation Settings (from animated.py)

These are built into `video_generator.py`:
- **Wipe Duration**: 6.5 seconds
- **Easing**: Cubic ease-out (smooth)
- **Feather Width**: 80 pixels (soft edge)
- **Direction**: Left to right
- **FPS**: 30
- **Codec**: H.264
- **Audio**: AAC

To change these, edit `video_generator.py` lines 49-77.

---

## 📁 Directory Structure

```
project_root/
├── video_generator.py              ← Python script (NEW)
├── animated.py                      ← Original test script
├── app/
│   ├── Http/Controllers/
│   │   └── VideoGenerationController.php  ← Updated
│   └── Models/
│       ├── GeneratedVideo.php       ← Video model
│       ├── Tempstore.php           ← Updated
│       └── BeforeGenerate.php      ← Uses existing
├── database/
│   └── migrations/
│       └── 2024_12_15_000001_add_video_support_to_tables.php  ← NEW
├── public/
│   ├── img/
│   │   └── user_template/          ← Customer PNG overlays (existing)
│   └── videos/
│       ├── background_video/       ← Background videos (NEW)
│       ├── generated_video/        ← Output videos (existing)
│       ├── thumbnails/             ← Video thumbnails (existing)
│       └── master_template/        ← Master templates (existing)
└── routes/
    └── web.php                      ← Routes already exist
```

---

## 💡 Pro Tips

1. **Start Small**: Test with 1-2 customers first
2. **Monitor Logs**: Keep Laravel log open during first run
3. **Check File Sizes**: Videos are much larger than images
4. **Disk Space**: Ensure enough space in `public/videos/`
5. **Performance**: Each video takes 2-5 minutes to generate
6. **Batch Size**: Controller commits every 5 videos to prevent timeout

---

## 📞 Need Help?

Check these files:
1. **Complete Checklist**: `VIDEO_GENERATION_CHECKLIST.md`
2. **Laravel Log**: `storage/logs/laravel.log`
3. **Video Guide**: `VIDEO_GENERATION_GUIDE.md`
4. **Python Script**: `video_generator.py` (has inline comments)

---

**Ready to Generate Videos? Start with Step 1! 🎥**
