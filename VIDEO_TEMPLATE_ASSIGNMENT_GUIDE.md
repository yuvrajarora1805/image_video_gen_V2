# Video Template Assignment Guide

## Overview
The video generation system now includes a complete template management workflow similar to the image generation system. This allows you to:
1. Create master video templates
2. Assign customers to video templates
3. Upload customer-specific PNG overlays
4. Generate personalized videos for each customer

---

## Complete Workflow

### Step 1: Create Master Video Template

**Purpose**: Create a master template that represents a video theme/category (e.g., "Birthday Wishes", "Holiday Greetings")

**Route**: `/video-templates` or `/create-video-template`

**Process**:
1. Navigate to "Video Templates" section
2. Click "Create New Template"
3. Fill in the form:
   - **Name**: Template name (e.g., "Birthday Video 2024")
   - **Video Type**: Select portrait or landscape
   - **Template Image**: Upload a reference PNG image (this is what the template looks like)
4. Click "Create Template"

**Result**: 
- Master template created in `video_templates` table
- Template image saved to `public/img/master_template/`
- Template appears in templates list with user count (initially 0)

---

### Step 2: Assign Customers to Video Template

**Purpose**: Link customers to the master template and upload their personalized PNG overlays

**Route**: `/assign` (Template Assignment page - same as image generation)

**Process**:
1. Navigate to "Assign Template" section
2. Fill in the form:
   - **Template Type**: Select "Video"
   - **Master Template**: Select your video template from dropdown
   - **Customer**: Select customer from dropdown
   - **Customer Template**: Upload customer's personalized PNG overlay
     - This PNG will be overlaid on the background video
     - Should contain customer-specific content (name, custom message, etc.)
     - Must be PNG with transparent background (RGBA)
3. Click "Assign Template"

**Result**:
- Entry created in `templates_by_user` table with:
  - `master_template_id`: Links to video template
  - `customer_id`: Links to customer
  - `customer_template`: PNG filename
  - `template_path`: Path to PNG
  - `content_type`: 'video'
- PNG saved to `public/img/user_template/`
- Template's user count increments

**Important Notes**:
- One customer can have multiple templates assigned (different masters)
- Same customer + same master template = update existing assignment
- PNG overlay should match video dimensions or will be auto-scaled

---

### Step 3: Create Video Generation Task

**Purpose**: Upload a background video and generate personalized videos for all assigned customers

**Route**: `/generate-video-form`

**Process**:
1. Navigate to "Generate Videos" section
2. Click "Create New Task"
3. Fill in the form:
   - **Master Template**: Select video template (shows user count)
   - **Background Video**: Upload the background video file (MP4, MOV, AVI, WMV)
   - Video will be combined with each customer's PNG overlay
4. Click "Create Task"

**Result**:
- Task created in `task` table with `task_type='video'`
- Background video saved to `public/videos/background_video/`
- Entry created in `before_genration` table with:
  - `mastertemplateid`: Links to template
  - `backgroundimage`: Video filename
  - `backgroundpath`: Full video path
  - `content_type`: 'video'
  - `taskid`: Links to task
  - `status`: 1 (ready to process)

**System Behavior**:
- Fetches all customers assigned to selected template
- Displays total videos that will be generated
- Each customer = 1 video output

---

### Step 4: Execute Video Generation Task

**Purpose**: Process the task to generate personalized videos

**Route**: `/generate-videos` then click "Execute" on task

**Process**:
1. Navigate to "Video Tasks" page
2. Find your task in the list
3. Click "Execute Task" button
4. System processes in background

**What Happens**:
For each customer assigned to the template:
1. Fetches customer's PNG overlay from `public/img/user_template/`
2. Calls Python script: `video_generator.py`
   ```
   python video_generator.py 
       [background_video.mp4]
       [customer_template.png] 
       [output_combined.mp4]
   ```
3. Python applies wipe-in animation (6.5 seconds)
4. Saves video to `public/videos/generated_video/`
5. Generates thumbnail using FFmpeg
6. Records in `generated_videos` table

**Result**:
- One MP4 video per customer
- All videos in `public/videos/generated_video/`
- Thumbnails in `public/videos/thumbnails/`
- Task status updated to "Completed"
- Shows processed count and failed count

---

### Step 5: Review and Download Videos

**Purpose**: View generated videos and download them

**Route**: `/generate-videos` then click "View Details" on completed task

**Actions Available**:
- View list of all generated videos
- Preview thumbnails
- Download individual videos
- Download all videos as ZIP
- Check which videos were sent

---

## Database Schema

### video_templates Table
```sql
id                  - Primary key
name                - Template name
video_type          - 'portrait' or 'landscape'
image_path          - Reference image filename
path                - Full path to reference image
is_active           - 1 or 0
created_at          - Timestamp
updated_at          - Timestamp
```

### templates_by_user Table (Shared with Image Generation)
```sql
id                      - Primary key
master_template_id      - Links to video_templates.id or templates.id
customer_id             - Links to customers.id
customer_template       - PNG overlay filename
template_path           - Full path to PNG
memtype                 - File extension
content_type            - 'image' or 'video'
created_at              - Timestamp
updated_at              - Timestamp
```

### generated_videos Table
```sql
id                  - Primary key
taskid              - Links to task.id
beforeid            - Links to before_genration.id
customerid          - Links to customers.id
video_template_id   - Links to video_templates.id
user_template_id    - Links to templates_by_user.id
video_path          - Output video filename
thumbnail_path      - Thumbnail filename
video_type          - 'portrait' or 'landscape'
duration            - Video duration in seconds
size                - File size in bytes
sent                - 0 or 1
sent_date           - Timestamp when sent
created_at          - Timestamp
updated_at          - Timestamp
```

---

## Routes Reference

### Video Template Management
```php
GET  /video-templates              - List all video templates
GET  /create-video-template        - Show create template form
POST /create-video-template        - Store new video template
DELETE /delete-video-template/{id} - Delete video template
GET  /get-video-template-image/{id} - Get template image for preview
GET  /getVideoUserDetails/{id}     - Get user count for template
```

### Template Assignment (Shared)
```php
GET  /assign                       - Show assignment page
GET  /assign-template              - Show assignment form
POST /assign-template              - Assign customer to template
DELETE /delete-item/{id}           - Delete assignment
```

### Video Generation
```php
GET  /generate-video-form          - Show video task creation form
POST /process-video-temp-data      - Create video task
GET  /generate-videos              - List video tasks
POST /execute-video-task/{id}      - Execute video generation
GET  /get-generated-videos/{taskId} - Get videos for task
GET  /download-video/{id}          - Download single video
GET  /download-task-videos/{taskId} - Download all videos as ZIP
```

---

## Controller Methods

### VideoGenerationController

#### Template Management
- `showVideoTemplates()` - Display templates list with user counts
- `showCreateVideoTemplateForm()` - Show template creation form
- `uploadVideoTemplate()` - Create new video template
- `deleteVideoTemplate($id)` - Delete template (checks if in use)
- `getUserDetails($templateId)` - Get count of assigned customers
- `getVideoTemplateImage($id)` - Get template preview image

#### Video Generation
- `showGenerateForm()` - Show task creation form
- `processVideoTempData()` - Create video task
- `showGenerateVideos()` - List tasks with statistics
- `executeVideoTask($id)` - Process video generation
- `getGeneratedVideos($taskId)` - Get videos for task
- `downloadVideo($id)` - Download single video
- `downloadTaskVideos($taskId)` - Download ZIP of all videos

### TemplateByCustomerController (Shared)

- `index()` - List all template assignments (image + video)
- `showCreateForm()` - Show assignment form with both template types
- `store()` - Assign customer to template (handles both types)
- `destroy($id)` - Delete assignment

---

## Model Scopes

### VideoTemplate Model

```php
// Get templates with user count
VideoTemplate::withUserCount()->get();

// Result includes:
// - All template fields
// - user_count (from templates_by_user where content_type='video')
```

### Template Model

```php
// Get image templates with user count
Template::withUserCount()->get();

// Result includes:
// - All template fields
// - user_count (from templates_by_user where content_type='image')
```

---

## Example: Complete Workflow

### Scenario: Birthday Video Campaign for 100 Customers

**Step 1: Create Template**
- Name: "Birthday 2024"
- Type: Landscape
- Image: birthday_template_preview.png
- Result: Template ID #5 created

**Step 2: Assign 100 Customers**
For each customer:
- Template Type: Video
- Master Template: "Birthday 2024" (#5)
- Customer: John Doe
- PNG Overlay: john_doe_birthday.png (with "Happy Birthday John!" text)
- Repeat for all 100 customers

Result: 100 entries in `templates_by_user` with `content_type='video'`

**Step 3: Create Task**
- Master Template: "Birthday 2024" (#5)
- Shows: "100 videos will be generated"
- Background Video: birthday_background_animation.mp4 (30 seconds)
- Result: Task #12 created

**Step 4: Execute Task**
- Click "Execute" on Task #12
- System processes 100 videos:
  - Video 1: birthday_background_animation.mp4 + john_doe_birthday.png
  - Video 2: birthday_background_animation.mp4 + jane_smith_birthday.png
  - ... and so on
- Processing time: ~5 hours (3 minutes per video)
- Result: 100 MP4 videos in `public/videos/generated_video/`

**Step 5: Distribute**
- Download all as ZIP
- Or download individually
- Send via WhatsApp/Email
- Mark as sent

---

## Key Differences from Image Generation

| Feature | Image Generation | Video Generation |
|---------|-----------------|------------------|
| Master Template | Image file | Reference image (for UI) |
| Background | Static image | Video file (MP4/MOV/AVI) |
| Customer Overlay | PNG template | Same PNG template |
| Processing | PHP GD | Python + MoviePy |
| Output | JPG image | MP4 video |
| Animation | None | 6.5s wipe-in effect |
| Time per item | ~1 second | ~3 minutes |
| File size | ~1 MB | ~30 MB |

---

## Common Use Cases

### 1. Personalized Birthday Videos
- Master Template: "Birthday Wishes"
- Background Video: Animated birthday scene
- Customer PNGs: Each with customer's name and photo
- Output: Personalized birthday video per customer

### 2. Holiday Greetings
- Master Template: "Christmas 2024"
- Background Video: Winter wonderland animation
- Customer PNGs: Company logo + customer name
- Output: Branded holiday greeting videos

### 3. Event Invitations
- Master Template: "Wedding Invitation"
- Background Video: Elegant floral animation
- Customer PNGs: Guest names and table numbers
- Output: Personalized invitation videos

### 4. Marketing Campaigns
- Master Template: "Product Launch"
- Background Video: Product showcase
- Customer PNGs: Customer-specific offers/codes
- Output: Targeted marketing videos

---

## Tips and Best Practices

### Template Creation
1. Use descriptive names (include year, occasion, version)
2. Choose appropriate video type (portrait for mobile, landscape for desktop)
3. Upload high-quality reference images
4. Test with 1-2 customers before bulk assignment

### Customer PNG Overlays
1. Use transparent backgrounds (RGBA PNG)
2. Match video dimensions or use standard sizes
3. Include clear, readable text
4. Test overlay visibility on background video
5. Keep file sizes reasonable (<5 MB)

### Background Videos
1. Use high-quality source videos
2. Keep duration reasonable (15-60 seconds typical)
3. Ensure video is well-lit and clear
4. Test that overlays are visible on background
5. Use common formats (MP4 recommended)

### Task Execution
1. Start with small batches (10-20 customers) to test
2. Run large batches during off-peak hours
3. Monitor logs for errors
4. Ensure sufficient disk space
5. Keep track of processing time estimates

### Organization
1. Use consistent naming conventions
2. Archive old tasks and videos
3. Regular cleanup of unused templates
4. Back up important videos before deletion
5. Document template purposes and usage

---

## Troubleshooting

### "No users assigned to template"
- Check that customers are assigned via `/assign` page
- Verify `content_type='video'` in database
- Ensure master_template_id matches

### "Template already exists"
- Use unique template names
- Or update existing template instead

### "Cannot delete template"
- Template has customers assigned
- Remove assignments first or keep template

### "Video generation fails"
- Check Python dependencies installed
- Verify FFmpeg is available
- Check background video file exists
- Verify customer PNG files exist
- Review Laravel logs for errors

### "User count shows 0"
- Ensure content_type is set correctly
- Check templates_by_user entries
- Verify withUserCount() scope is used

---

## Summary

The video template assignment system works exactly like image generation:
1. ✅ Create master templates (`video_templates` table)
2. ✅ Assign customers to templates (`templates_by_user` table with `content_type='video'`)
3. ✅ Upload customer PNG overlays (same location as images)
4. ✅ Create tasks with background videos
5. ✅ Generate personalized videos (Python + MoviePy)
6. ✅ Download and distribute

**Key Advantage**: Reuses all existing infrastructure while adding video capabilities!

---

**Last Updated**: December 15, 2024
