# Video Generation Feature - Complete Implementation Guide

## Overview
This feature allows generating videos by overlaying customer videos on background video templates.
Supports two video types:
- **Portrait (Reels)**: 1080x1920 (9:16 ratio) - for Instagram Reels, YouTube Shorts, TikTok
- **Landscape**: 1920x1080 (16:9 ratio) - for YouTube, Facebook videos

## Prerequisites
Install FFmpeg on your system:
```powershell
# Windows: Download from https://ffmpeg.org/download.html
# Or use Chocolatey:
choco install ffmpeg

# Verify installation:
ffmpeg -version
```

## Phase 1: Database Setup

### Step 1.1: Run Database Migrations
```powershell
cd D:\xamp\htdocs\imgen\public_html\public_html
mysql -u root laravel < database\migrations\video_generation_schema.sql
```

### Step 1.2: Verify Tables Created
```powershell
mysql -u root -e "SHOW TABLES FROM laravel LIKE '%video%';"
```

## Phase 2: Create Models

### Step 2.1: Create VideoTemplate Model
Location: `app/Models/VideoTemplate.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VideoTemplate extends Model
{
    protected $table = 'video_templates';
    
    protected $fillable = [
        'name',
        'video_type',
        'path',
        'video_file',
        'thumbnail',
        'duration',
        'width',
        'height',
        'is_active'
    ];

    public function videosByUser()
    {
        return $this->hasMany(VideosByUser::class, 'master_video_id');
    }
}
```

### Step 2.2: Create VideosByUser Model
Location: `app/Models/VideosByUser.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VideosByUser extends Model
{
    protected $table = 'videos_by_user';
    
    protected $fillable = [
        'customer_id',
        'master_video_id',
        'customer_video',
        'video_path',
        'thumbnail',
        'duration',
        'width',
        'height'
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    public function masterVideo()
    {
        return $this->belongsTo(VideoTemplate::class, 'master_video_id');
    }
}
```

### Step 2.3: Create GeneratedVideo Model
Location: `app/Models/GeneratedVideo.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GeneratedVideo extends Model
{
    protected $table = 'generated_videos';
    
    protected $fillable = [
        'taskid',
        'beforeid',
        'customer_id',
        'master_video_id',
        'user_video_id',
        'generated_path',
        'generated_video',
        'thumbnail',
        'video_type',
        'duration',
        'file_size',
        'sent',
        'sent_date'
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    public function task()
    {
        return $this->belongsTo(Task::class, 'taskid');
    }
}
```

## Phase 3: Video Processing Logic

### Step 3.1: FFmpeg Helper Class
Location: `app/Services/VideoProcessor.php`

```php
<?php

namespace App\Services;

use FFMpeg\FFMpeg;
use FFMpeg\Coordinate\Dimension;
use FFMpeg\Format\Video\X264;

class VideoProcessor
{
    private $ffmpeg;

    public function __construct()
    {
        $this->ffmpeg = FFMpeg::create([
            'ffmpeg.binaries'  => 'C:/ffmpeg/bin/ffmpeg.exe', // Adjust path
            'ffprobe.binaries' => 'C:/ffmpeg/bin/ffprobe.exe',
            'timeout'          => 3600,
            'ffmpeg.threads'   => 12,
        ]);
    }

    /**
     * Overlay customer video on background video
     */
    public function overlayVideos($backgroundPath, $overlayPath, $outputPath, $videoType = 'portrait')
    {
        // Set dimensions based on video type
        $dimensions = $videoType === 'portrait' 
            ? ['width' => 1080, 'height' => 1920]  // 9:16 for Reels
            : ['width' => 1920, 'height' => 1080]; // 16:9 for Landscape

        // FFmpeg command to overlay videos
        $command = sprintf(
            'ffmpeg -i %s -i %s -filter_complex "[0:v]scale=%d:%d[bg];[1:v]scale=%d:%d[fg];[bg][fg]overlay=0:0" -c:v libx264 -preset medium -crf 23 %s',
            escapeshellarg($backgroundPath),
            escapeshellarg($overlayPath),
            $dimensions['width'],
            $dimensions['height'],
            $dimensions['width'],
            $dimensions['height'],
            escapeshellarg($outputPath)
        );

        exec($command, $output, $returnCode);

        return $returnCode === 0;
    }

    /**
     * Get video information
     */
    public function getVideoInfo($videoPath)
    {
        $video = $this->ffmpeg->open($videoPath);
        $duration = $video->getStreams()->videos()->first()->get('duration');
        $dimensions = $video->getStreams()->videos()->first()->getDimensions();

        return [
            'duration' => (int)$duration,
            'width' => $dimensions->getWidth(),
            'height' => $dimensions->getHeight(),
        ];
    }

    /**
     * Generate thumbnail from video
     */
    public function generateThumbnail($videoPath, $thumbnailPath, $timeInSeconds = 1)
    {
        $video = $this->ffmpeg->open($videoPath);
        $frame = $video->frame(\FFMpeg\Coordinate\TimeCode::fromSeconds($timeInSeconds));
        $frame->save($thumbnailPath);

        return file_exists($thumbnailPath);
    }
}
```

## Phase 4: Directory Structure

Create these directories in `public/videos/`:
```
public/
  videos/
    master_template/     # Background videos
    user_template/       # Customer videos
    generated_video/     # Output videos
    thumbnails/          # Video thumbnails
```

```powershell
# Create directories
New-Item -ItemType Directory -Force -Path "public/videos/master_template"
New-Item -ItemType Directory -Force -Path "public/videos/user_template"
New-Item -ItemType Directory -Force -Path "public/videos/generated_video"
New-Item -ItemType Directory -Force -Path "public/videos/thumbnails"
```

## Phase 5: Routes

Add to `routes/web.php`:

```php
// Video Template Management
Route::get('/video-templates', [VideoGenerationController::class, 'showVideoTemplates'])->name('video-templates');
Route::post('/upload-video-template', [VideoGenerationController::class, 'uploadVideoTemplate'])->name('upload-video-template');

// Customer Video Assignment
Route::get('/assign-customer-videos', [VideoGenerationController::class, 'showAssignVideos'])->name('assign-customer-videos');
Route::post('/assign-video-to-customer', [VideoGenerationController::class, 'assignVideoToCustomer'])->name('assign-video-to-customer');

// Video Generation
Route::get('/generate-videos', [VideoGenerationController::class, 'showGenerateVideos'])->name('generate-videos');
Route::post('/create-video-task', [VideoGenerationController::class, 'createVideoTask'])->name('create-video-task');
Route::post('/execute-video-task/{id}', [VideoGenerationController::class, 'executeVideoTask'])->name('execute-video-task');
```

## Next Steps

Would you like me to:
1. Create the VideoGenerationController with all methods?
2. Create the UI views for video upload and generation?
3. Set up the API endpoints for video download?
4. Install FFmpeg and test video processing?

Let me know which part you'd like to implement first!
