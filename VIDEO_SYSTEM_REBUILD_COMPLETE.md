# Video Generation System - Complete Rebuild Summary

## Overview
The video generation system has been completely rebuilt to mirror the image generation architecture exactly, using the same workflow, database structure, and customer assignment logic while applying animated.py's wipe-in animation during video combining.

## System Architecture

### Master Template Management
**Image System:**
- Controller: `TemplateController.php`
- Model: `Template.php`
- Views: `resources/views/master-template/`
  - `index.blade.php` - AJAX-powered template listing
  - `create-templates.blade.php` - Upload form
- Routes: `/template`, `/create-template`
- Storage: `public/img/master_template/`

**Video System (NEW - Identical Structure):**
- Controller: `VideoTemplateController.php` ✅
- Model: `VideoTemplate.php`
- Views: `resources/views/video-master-template/` ✅
  - `index.blade.php` - AJAX-powered template listing
  - `create-templates.blade.php` - Upload form  
- Routes: `/video-template`, `/create-video-template-master` ✅
- Storage: `public/videos/background_video/`

### Customer Assignment
**Shared System (Both Image & Video):**
- Controller: `TemplateByCustomerController.php`
- Model: `TemplatesByUser.php`
- Table: `templates_by_user`
  - `master_template_id` - Links to templates OR video_templates
  - `customer_id` - Links to customers
  - `customer_template` - PNG overlay filename
  - `content_type` - ENUM('image', 'video')
- Views: `resources/views/assign/`
- Routes: `/assign`, `/assign-template`
- Storage: `public/img/user_template/` (PNG overlays for both systems)

### Task Creation & Generation

**Image System:**
1. User selects master template
2. Uploads background image
3. Data saved to `Tempstore` table
4. `processTempData()` creates Task + `before_genration` entries
5. `executeTask()` combines background image + customer PNGs using PHP GD
6. Output saved to `generated_image` table

**Video System (NEW - Mirrors Image Exactly):**
1. User selects video master template ✅
2. Uploads background video ✅
3. Data saved to `Tempstore` table with `content_type='video'` ✅
4. `processVideoTempData()` creates Task + `before_genration` entries ✅
5. `executeVideoTask()` calls Python script for each customer:
   ```php
   python video_generator.py bg_video.mp4 customer_template.png output.mp4
   ```
   - Uses animated.py wipe-in logic (6.5s, 80px feather, cubic ease-out) ✅
6. Output saved to `generated_videos` table ✅

## Database Schema

### Shared Tables
- `customers` - Customer database
- `templates_by_user` - Customer PNG assignments for both image/video
- `before_genration` - Task preparation data (with `content_type` field)
- `task` - Task tracking (with `task_type` field)
- `logs` - Success logs
- `errorlogs` - Error tracking
- `tempstore` - Temporary form data (with `content_type` field)

### Image-Specific Tables
- `templates` - Master image templates
- `generated_image` - Generated image outputs

### Video-Specific Tables
- `video_templates` - Master video templates
- `generated_videos` - Generated video outputs

## Code Changes Summary

### ✅ Completed

1. **VideoTemplateController.php** (NEW)
   - `index()` - List video templates with AJAX support + withUserCount() scope
   - `showCreateForm()` - Display create form
   - `store()` - Upload video template, validate duplicates
   - `destroy()` - Delete template with usage check
   - `getTemplateImage()` - Return template preview

2. **VideoGenerationController.php** (UPDATED)
   - **Added imports:** Tempstore, Logs, Errorlogs, TemplatesByUser
   - **showGenerateForm()** - Updated to use `VideoTemplate::all()`
   - **getUserDetails($masterTemplateId)** - Fetches count from templates_by_user where content_type='video'
   - **processVideoTempData()** - NEW: Mirrors ImageGenerationController
     - Reads from Tempstore where content_type='video'
     - Creates Task with task_type='video'
     - Creates before_genration entries
     - Logs to Logs table
     - Clears Tempstore
   - **executeVideoTask($id)** - UPDATED: Mirrors ImageGenerationController
     - Fetches TemplatesByUser where content_type='video'
     - Loops through each customer template (PNG overlay)
     - Calls `generateVideoWithPython()` for each combination
     - Saves to GeneratedVideo model matching ImageGeneration structure
     - Updates task status to "Generated - Ready to Send"
     - Logs to Logs/Errorlogs tables
   - **showGenerateVideos()** - UPDATED: Fixed table join to use templates_by_user

3. **Blade Views** (NEW)
   - `resources/views/video-master-template/index.blade.php`
     - Copied from master-template/index.blade.php
     - Updated title to "Video Master Templates 🎬"
     - Changed AJAX URL to `/video-template`
     - Updated route to `create-video-template-form`
     - Displays video preview instead of image
   - `resources/views/video-master-template/create-templates.blade.php`
     - Copied from master-template/create-templates.blade.php
     - Updated form action to `create-video-template`
     - Changed input accept to video formats
     - Updated labels for video context

4. **Routes** (web.php)
   - Added VideoTemplateController import
   - Added video master template routes:
     ```php
     GET  /video-template                    -> VideoTemplateController@index
     GET  /create-video-template-master      -> VideoTemplateController@showCreateForm
     POST /create-video-template-master      -> VideoTemplateController@store
     DELETE /delete-video-template-master/{id} -> VideoTemplateController@destroy
     GET  /get-video-template-master-image/{id} -> VideoTemplateController@getTemplateImage
     ```

### 🔄 Pending (To Complete Full Parity)

1. **Video Generation Form View**
   - Create `resources/views/video/generate_video.form.blade.php`
   - Mirror `generate_image/form.blade.php`
   - Select video master template dropdown
   - Upload background video file
   - Show customer count
   - Save to Tempstore with content_type='video'

2. **Video Generation List View**
   - Create `resources/views/video/generate_video.blade.php`
   - Mirror `generate_image/generate_image.blade.php`
   - List video tasks with counts
   - Execute task button calls `/execute-video-task/{id}`
   - Show generated videos
   - Download/send options

3. **Template Assignment Enhancement**
   - Update `TemplateByCustomerController`
   - Add toggle/dropdown to select content_type (image/video)
   - When selecting video template, set content_type='video'
   - Upload customer PNG overlay (same as image system)

4. **Tempstore Updates**
   - Ensure `TempFormController` supports video data
   - Add method to store video template + background video to Tempstore
   - Set content_type='video' field

## Workflow Comparison

### Image Generation Workflow
```
1. Master Template Management
   └─> Upload PNG template to templates table

2. Customer Assignment  
   └─> Assign customers to template in templates_by_user
   └─> Upload customer-specific PNG overlay

3. Task Creation
   └─> Select master template
   └─> Upload background image
   └─> Save to Tempstore

4. Process Task
   └─> processTempData() creates Task + before_genration

5. Execute Task
   └─> executeTask() loops through templates_by_user
   └─> Combines background + overlay using PHP GD
   └─> Saves to generated_image table
```

### Video Generation Workflow (NEW - Identical)
```
1. Master Template Management ✅
   └─> Upload video template to video_templates table

2. Customer Assignment (SAME TABLE)
   └─> Assign customers to video template in templates_by_user
   └─> Upload customer-specific PNG overlay (same as image)
   └─> Set content_type='video'

3. Task Creation
   └─> Select video master template
   └─> Upload background video
   └─> Save to Tempstore with content_type='video' ✅

4. Process Task ✅
   └─> processVideoTempData() creates Task + before_genration

5. Execute Task ✅
   └─> executeVideoTask() loops through templates_by_user
   └─> Calls Python script: video_generator.py (animated.py logic)
   └─> Saves to generated_videos table
```

## Python Integration

### video_generator.py (Already Created)
```python
# CLI: python video_generator.py <bg_video> <template_png> <output_mp4>
# Animation: 6.5-second wipe-in effect
# Feather: 80-pixel soft edge
# Easing: Cubic ease-out
# Output: H.264 video, AAC audio, 30fps
```

**Called from PHP:**
```php
$command = sprintf(
    'python "%s" "%s" "%s" "%s"',
    base_path('video_generator.py'),
    $backgroundVideoPath,  // From before_genration.backgroundpath
    $customerTemplatePath, // From templates_by_user.customer_template
    $outputPath            // videos/generated_video/combined_video_XXX.mp4
);
exec($command, $output, $returnCode);
```

## Key Differences Between Image & Video

| Aspect | Image System | Video System |
|--------|-------------|--------------|
| **Master Template Storage** | `public/img/master_template/` | `public/videos/background_video/` |
| **Master Template Table** | `templates` | `video_templates` |
| **Background Input** | PNG/JPG image file | MP4 video file |
| **Processing Engine** | PHP GD Library | Python MoviePy + FFmpeg |
| **Output Table** | `generated_image` | `generated_videos` |
| **Output Storage** | `public/img/generated_image/` | `public/videos/generated_video/` |
| **Task Type** | NULL or 'image' | 'video' |
| **Content Type** | 'image' | 'video' |
| **Customer Overlay** | PNG (from templates_by_user) | PNG (SAME - from templates_by_user) |
| **Animation** | None (static overlay) | Wipe-in effect (6.5s, animated.py) |
| **Additional Outputs** | None | Video thumbnail (JPG) |

## File Structure
```
d:/xamp/htdocs/imgen/public_html/public_html/
├── app/
│   └── Http/
│       └── Controllers/
│           ├── ImageGenerationController.php       (Original)
│           ├── TemplateController.php              (Original - Image templates)
│           ├── VideoTemplateController.php         (NEW ✅ - Video templates)
│           ├── VideoGenerationController.php       (UPDATED ✅)
│           └── TemplateByCustomerController.php    (Shared - needs update)
├── resources/
│   └── views/
│       ├── master-template/
│       │   ├── index.blade.php                     (Image templates)
│       │   └── create-templates.blade.php          (Image templates)
│       ├── video-master-template/                  (NEW ✅)
│       │   ├── index.blade.php                     (Video templates)
│       │   └── create-templates.blade.php          (Video templates)
│       ├── generate_image/
│       │   ├── form.blade.php                      (Image task creation)
│       │   └── generate_image.blade.php            (Image task list)
│       └── video/
│           ├── form.blade.php                      (NEEDS UPDATE)
│           └── generate.blade.php                  (NEEDS UPDATE - rename to generate_video.blade.php)
├── routes/
│   └── web.php                                     (UPDATED ✅)
├── public/
│   ├── img/
│   │   ├── master_template/                        (Image master templates)
│   │   ├── user_template/                          (SHARED - customer PNG overlays)
│   │   ├── background_image/                       (Background images for tasks)
│   │   └── generated_image/                        (Generated images)
│   └── videos/
│       ├── background_video/                       (Background videos for tasks)
│       ├── generated_video/                        (Generated videos)
│       └── thumbnails/                             (Video thumbnails)
└── video_generator.py                              (Python script with animated.py logic)
```

## Next Steps

### To Complete Video System (Remaining 3 Tasks):

1. **Update Video Generation Form** (`video/form.blade.php`)
   - Copy structure from `generate_image/form.blade.php`
   - Change to video file input
   - Update AJAX calls to use VideoTemplate endpoints
   - Save to Tempstore with content_type='video'

2. **Update Video Generation List** (`video/generate.blade.php` → `video/generate_video.blade.php`)
   - Copy structure from `generate_image/generate_image.blade.php`
   - Update task list to show video counts
   - Execute button calls `/execute-video-task/{id}`
   - Add video preview instead of image preview

3. **Update Template Assignment** (`TemplateByCustomerController`)
   - Add content_type field selection
   - When video template selected, set content_type='video'
   - Upload customer PNG overlay (same storage location)

### Testing Workflow

1. Create video master template at `/video-template`
2. Assign customers with PNG overlays at `/assign` (content_type='video')
3. Create task at `/generate-video-form` (upload background video)
4. View tasks at `/generate-videos`
5. Execute task (calls Python script)
6. Verify:
   - Output videos in `public/videos/generated_video/`
   - Wipe-in animation applied (6.5s, 80px feather)
   - Thumbnails generated
   - Database entries in `generated_videos` table
   - Task status updates correctly

## Technical Notes

### Tempstore Usage
The Tempstore table temporarily holds form data before task creation:

**Image:**
```php
Tempstore::create([
    'mastertemplateid' => $templateId,
    'backgroundimage' => $imageFileName,
    'backgroundpath' => $imagePath,
    'content_type' => 'image'
]);
```

**Video (Need to implement in TempFormController):**
```php
Tempstore::create([
    'mastertemplateid' => $videoTemplateId,
    'backgroundimage' => $videoFileName,
    'backgroundpath' => $videoPath,
    'content_type' => 'video',
    'video_type' => $videoType // portrait/landscape
]);
```

### Python Script Execution
```php
// VideoGenerationController@generateVideoWithPython()
$pythonScript = base_path('video_generator.py');
$command = sprintf(
    'python "%s" "%s" "%s" "%s" 2>&1',
    $pythonScript,
    $backgroundVideoPath,
    $templatePath,
    $outputPath
);
exec($command, $outputLines, $returnCode);
```

### FFmpeg Thumbnail Generation
```php
// VideoGenerationController@generateThumbnail()
$command = sprintf(
    'ffmpeg -i "%s" -ss 00:00:01 -vframes 1 -q:v 2 "%s" 2>&1',
    $videoPath,
    $thumbnailPath
);
exec($command, $output, $returnCode);
```

## Success Criteria

✅ Video master template CRUD matches image template exactly  
✅ VideoTemplateController mirrors TemplateController  
✅ VideoGenerationController mirrors ImageGenerationController  
✅ Routes configured for video templates  
✅ Views created for video master template management  
✅ Database structure supports video workflow  
✅ Python script applies animated.py wipe-in logic  
⏳ Video generation form created  
⏳ Video task list view created  
⏳ Template assignment supports video content_type  
⏳ End-to-end workflow tested  

## Documentation Files

- `VIDEO_GENERATION_GUIDE.md` - Original implementation guide
- `VIDEO_GENERATION_CHECKLIST.md` - Step-by-step checklist
- `QUICK_VIDEO_SETUP.md` - Quick start guide
- `IMAGE_VS_VIDEO_COMPARISON.md` - Feature comparison
- `VIDEO_TEMPLATE_ASSIGNMENT_GUIDE.md` - Assignment workflow
- `VIDEO_SYSTEM_REBUILD_COMPLETE.md` - This file (master reference)

---

**Last Updated:** December 2024  
**Status:** Core architecture completed ✅ | Views pending ⏳ | Testing pending ⏳
