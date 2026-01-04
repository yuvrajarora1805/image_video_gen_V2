# Image & Video Generation System V2

A powerful Laravel-based web application for automated image and video generation with queue management, parallel processing, and GPU acceleration support.

## 🚀 Features

- **Automated Video Generation**: Create videos from images with custom animations and transitions
- **Queue Management System**: Efficient task queuing with status tracking
- **Parallel Processing**: Multi-worker architecture for concurrent video generation
- **GPU Acceleration**: NVIDIA NVENC and Intel Quick Sync support for faster encoding
- **Social Media Integration**: Direct upload to Instagram and Facebook
- **Template Management**: Customizable video templates with various animation effects
- **RESTful API**: Complete API for task management and video generation
- **Real-time Status Tracking**: Monitor video generation progress in real-time

## 📋 Prerequisites

### System Requirements
- **PHP**: 8.1 or higher
- **Python**: 3.8 or higher
- **MySQL/MariaDB**: 5.7 or higher
- **Composer**: Latest version
- **Node.js & NPM**: Latest LTS version
- **FFmpeg**: Latest version with GPU support (optional but recommended)

### Python Dependencies
- moviepy
- Pillow
- requests
- mysql-connector-python
- facebook-sdk (for Facebook uploads)
- instagrapi (for Instagram uploads)

### Optional (for GPU Acceleration)
- NVIDIA GPU with CUDA support
- Intel GPU with Quick Sync support

## 🛠️ Installation

### 1. Clone the Repository
```bash
git clone https://github.com/yuvrajarora1805/image_video_gen_V2.git
cd image_video_gen_V2
```

### 2. Install PHP Dependencies
```bash
composer install
```

### 3. Install Node Dependencies
```bash
npm install
```

### 4. Install Python Dependencies
```bash
pip install moviepy Pillow requests mysql-connector-python facebook-sdk instagrapi
```

### 5. Environment Configuration
```bash
# Copy the example environment file
cp .env.example .env

# Generate application key
php artisan key:generate
```

### 6. Configure Environment Variables
Edit `.env` file and set the following:

```env
# Application
APP_NAME="Image Video Gen V2"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password

# File Paths (adjust to your system)
# Windows example:
# VIDEO_OUTPUT_PATH=D:/xamp/htdocs/imgen/public_html/public_html/public/videos
# MUSIC_PATH=D:/xamp/htdocs/imgen/public_html/public_html/public/music

# Social Media API Keys (optional)
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
INSTAGRAM_USERNAME=your_instagram_username
INSTAGRAM_PASSWORD=your_instagram_password
```

### 7. Database Setup

#### Create Database
```bash
# Login to MySQL
mysql -u root -p

# Create database
CREATE DATABASE your_database_name;
exit;
```

#### Run Migrations
```bash
# Run the main video generation schema
mysql -u your_user -p your_database_name < database/migrations/video_generation_schema.sql

# Or use Laravel migrations
php artisan migrate
```

### 8. Set Directory Permissions

#### Linux/Mac
```bash
chmod -R 775 storage bootstrap/cache
chmod -R 775 public/videos public/img/user_template
chown -R www-data:www-data storage bootstrap/cache
```

#### Windows
Ensure the web server has write permissions to:
- `storage/`
- `bootstrap/cache/`
- `public/videos/`
- `public/img/user_template/`

### 9. Install FFmpeg

#### Windows
1. Download FFmpeg from [ffmpeg.org](https://ffmpeg.org/download.html)
2. Extract and add to system PATH
3. Verify: `ffmpeg -version`

#### Linux
```bash
sudo apt update
sudo apt install ffmpeg
```

#### Mac
```bash
brew install ffmpeg
```

## 🎬 Running the Application

### 1. Start the Web Server

#### Using PHP Built-in Server
```bash
php artisan serve
```
Access at: `http://localhost:8000`

#### Using XAMPP/WAMP
1. Place project in `htdocs` or `www` directory
2. Configure virtual host
3. Access via configured domain

### 2. Start Video Generation Workers

#### Windows
```bash
# Start worker processes
start_workers.bat
```

#### Linux/Mac
```bash
# Make script executable
chmod +x start_workers.sh

# Start workers
./start_workers.sh
```

#### Manual Worker Start
```bash
# Start individual worker
python run_workers.py
```

### 3. Access the Application

- **Main Dashboard**: `http://localhost:8000`
- **Video Generation**: `http://localhost:8000/generate`
- **API Documentation**: `http://localhost:8000/api/tasks`

## 📚 Usage Guide

### Creating a Video Generation Task

1. **Via Web Interface**:
   - Navigate to `/generate`
   - Upload images
   - Select template and animation
   - Configure video settings
   - Click "Generate Video"

2. **Via API**:
```bash
curl -X POST http://localhost:8000/api/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "CUST001",
    "template_id": 1,
    "images": ["image1.jpg", "image2.jpg"],
    "animation": "slide_in",
    "music": "background.mp3"
  }'
```

### Monitoring Task Status

```bash
# Get all tasks
curl http://localhost:8000/api/tasks

# Get specific task
curl http://localhost:8000/api/tasks/{task_id}

# Get task status
curl http://localhost:8000/api/tasks/{task_id}/status
```

### Managing Workers

```bash
# Check worker status
python run_workers.py --status

# Stop all workers
python run_workers.py --stop

# Restart workers
python run_workers.py --restart
```

## 🔧 Configuration

### GPU Acceleration

Edit `parallel_video_generator.py` to enable GPU:

```python
# Enable NVIDIA NVENC
USE_GPU = True
GPU_ENCODER = "h264_nvenc"

# Or use Intel Quick Sync
GPU_ENCODER = "h264_qsv"
```

### Parallel Processing

Configure worker count in `start_workers.bat`:

```batch
REM Adjust number of workers (default: 3)
set WORKER_COUNT=3
```

### Animation Effects

Available animations in `animation_library.py`:
- `fade_in` - Fade in effect
- `slide_in` - Slide from side
- `zoom_in` - Zoom effect
- `wipe` - Wipe transition
- `flip` - 3D flip effect
- `blur` - Blur transition
- `spiral` - Spiral effect
- `corner_wipe` - Corner wipe
- `bounce` - Bounce effect

## 📁 Project Structure

```
├── app/
│   ├── Http/Controllers/
│   │   ├── ApiController.php          # API endpoints
│   │   ├── VideoController.php        # Video generation logic
│   │   └── ImageGenerationController.php
│   └── Models/
│       ├── VideoTask.php              # Task model
│       └── VideoTemplate.php          # Template model
├── database/
│   └── migrations/
│       └── video_generation_schema.sql
├── public/
│   ├── videos/                        # Generated videos
│   ├── img/user_template/             # User templates
│   └── music/                         # Background music
├── resources/views/
│   ├── generate.blade.php             # Video generation UI
│   └── layouts/
├── routes/
│   ├── web.php                        # Web routes
│   └── api.php                        # API routes
├── parallel_video_generator.py        # Main video generator
├── animation_library.py               # Animation effects
├── run_workers.py                     # Worker manager
├── start_workers.bat                  # Worker launcher (Windows)
└── .env                               # Environment configuration
```

## 🐛 Troubleshooting

### Videos Not Generating
1. Check worker logs: `workers.log`
2. Verify FFmpeg installation: `ffmpeg -version`
3. Check database connection
4. Ensure proper file permissions

### GPU Not Detected
1. Install NVIDIA drivers (for NVENC)
2. Verify GPU support: `python test_gpu.py`
3. Check FFmpeg GPU build: `ffmpeg -encoders | grep nvenc`

### Database Connection Issues
1. Verify MySQL is running
2. Check `.env` database credentials
3. Ensure database exists
4. Run migrations: `php artisan migrate`

### Permission Errors
1. Set proper directory permissions
2. Check web server user
3. Verify storage directory access

## 📊 Database Schema

Key tables:
- `video_tasks` - Video generation tasks
- `video_templates` - Template configurations
- `customers` - Customer information
- `customer_videos` - Generated video records

See `database/migrations/video_generation_schema.sql` for complete schema.

## 🔐 Security

- Never commit `.env` file
- Keep credentials in `*_creds.txt` files (gitignored)
- Use environment variables for sensitive data
- Implement proper authentication for production
- Sanitize user inputs
- Use HTTPS in production

## 📝 API Endpoints

### Tasks
- `GET /api/tasks` - List all tasks
- `POST /api/tasks` - Create new task
- `GET /api/tasks/{id}` - Get task details
- `PUT /api/tasks/{id}` - Update task
- `DELETE /api/tasks/{id}` - Delete task
- `POST /api/tasks/{id}/execute` - Execute task

### Videos
- `GET /api/videos` - List generated videos
- `GET /api/videos/{id}` - Get video details
- `POST /api/videos/upload` - Upload to social media

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit pull request

## 📄 License

This project is proprietary software. All rights reserved.

## 👤 Author

**Yuvraj Arora**
- GitHub: [@yuvrajarora1805](https://github.com/yuvrajarora1805)

## 🙏 Acknowledgments

- Laravel Framework
- MoviePy Library
- FFmpeg Project
- Intervention Image

## 📞 Support

For issues and questions:
1. Check existing documentation
2. Review troubleshooting section
3. Check logs in `workers.log` and `storage/logs/`
4. Create an issue on GitHub

---

**Version**: 2.0  
**Last Updated**: January 2026