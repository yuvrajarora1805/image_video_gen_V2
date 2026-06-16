# Video Generation System

A powerful Laravel-based video generation system with GPU acceleration support, queue-based processing, and Instagram/Facebook integration.

## Features

- ✅ **Automated Video Generation** - Create videos by overlaying custom templates on background videos
- ✅ **GPU Acceleration** - NVENC support for 2-4x faster video encoding
- ✅ **Queue System** - Parallel processing with multiple workers
- ✅ **Real-time Progress** - Live progress updates as videos generate
- ✅ **Multiple Rendering Engines** - FFmpeg (default) and MoviePy support
- ✅ **Animation Effects** - 11+ animation effects for template overlays
- ✅ **Social Media Integration** - Direct upload to Instagram and Facebook
- ✅ **Customer Management** - Multi-customer support with custom templates

## System Requirements

### Required Software
- **PHP 8.1+** with extensions: OpenSSL, PDO, Mbstring, Tokenizer, XML, Ctype, JSON, BCMath, Fileinfo, GD/Imagick
- **Python 3.10+** with packages: moviepy, Pillow, numpy, opencv-python
- **MySQL 8.0+**
- **FFmpeg** (with GPU support if available)
- **Composer** (PHP dependency manager)
- **Web Server** (Apache/Nginx)

### Optional
- **NVIDIA GPU** with NVENC support for hardware acceleration
- **CUDA** for GPU-accelerated video processing

## Installation

### 1. Clone/Copy Project
```bash
# Copy project to your web directory
# Example: C:\xampp\htdocs\video-gen
```

### 2. Install Dependencies
```bash
# PHP dependencies
composer install --optimize-autoloader --no-dev

# Python dependencies
pip install moviepy Pillow numpy opencv-python
```

### 3. Configure Environment
```bash
# Copy example env file
cp .env.example .env

# Generate application key
php artisan key:generate

# Edit .env with your settings
```

### 4. Update System Paths in `.env`
```env
# Update these paths for your system
PYTHON_PATH=C:\Path\To\python.exe
PHP_PATH=C:\Path\To\php.exe

# Database configuration
DB_DATABASE=your_database_name
DB_USERNAME=your_db_username
DB_PASSWORD=your_db_password
```

### 5. Database Setup

**Option A: Automated Setup (Recommended)**
```bash
# Run migrations to create tables
php artisan migrate

# Clear cache
php artisan config:clear
```

**Option B: Manual Import**
1. Create a database (e.g., `laravel`)
2. Import the provided `database_structure.sql` file using PHPMyAdmin or MySQL Workbench.


### 6. Create Required Directories
```bash
# Create storage directories
mkdir -p storage/app/gpu_tasks
mkdir -p storage/logs
mkdir -p public/img/{master_template,user_template,background_image,generated_image}
mkdir -p public/videos/{master_template,user_template,background_video,generated_video,thumbnails}
```

### 7. Set Permissions
**Windows:**
- Right-click folders → Properties → Security
- Give full control to your web server user

**Linux/Mac:**
```bash
chmod -R 775 storage bootstrap/cache
chmod -R 775 public/img public/videos
chown -R www-data:www-data storage bootstrap/cache public/img public/videos
```

## Usage

### Start Queue Workers
```bash
# Start persistent workers (recommended)
python run_workers_persistent.py

# Or start auto-stopping workers
python run_workers.py
```

### Access Application
Navigate to your application URL in a web browser:
```
http://localhost/your-project/public
```

### Create Video Task
1. Navigate to "Create Video Task"
2. Select a video template
3. Upload background video
4. Choose animation effect
5. Select rendering engine (FFmpeg recommended)
6. Click "Add" then "Submit"
7. Workers will process the task automatically

## Configuration

### GPU Acceleration
Enable/disable GPU in the UI or update `.env`:
```env
USE_GPU=1  # 1 = enabled, 0 = disabled
FORCE_NVENC=1  # Force NVIDIA NVENC encoder
USE_CUDA_DECODE=1  # Use CUDA for decoding
```

### Rendering Engine
Default is FFmpeg (faster, GPU-optimized). Can be changed per task in the UI.

### Queue Workers
Adjust number of workers in `run_workers_persistent.py`:
```python
NUM_WORKERS = 4  # Change to desired number
```

## Project Structure

```
├── app/                    # Laravel application code
│   ├── Http/Controllers/   # Controllers
│   ├── Jobs/               # Queue jobs
│   └── Models/             # Eloquent models
├── database/               # Migrations and seeders
├── public/                 # Public assets and uploads
│   ├── img/                # Image templates and generated images
│   └── videos/             # Video templates and generated videos
├── resources/              # Views and frontend assets
├── routes/                 # Application routes
├── storage/                # Logs and temporary files
├── video_generator.py      # Main video generation script
├── parallel_video_generator.py  # GPU parallel processing
├── ffmpeg_parallel_generator.py # FFmpeg parallel processing
├── run_workers_persistent.py    # Worker launcher
└── .env                    # Environment configuration
```

## Troubleshooting

### Python not found
**Solution:** Add Python to system PATH or use full path in `.env`

### FFmpeg not found
**Solution:** Install FFmpeg and add to system PATH

### Permission denied on storage
**Solution:** Set correct permissions (see Installation step 7)

### Database connection failed
**Solution:** Check `.env` database credentials and ensure MySQL is running

### Queue workers not starting
**Solution:** Check PHP path in `run_workers_persistent.py` or `.env`

## Support

For issues:
1. Check `storage/logs/laravel.log`
2. Check web server error logs
3. Verify all paths are correct in `.env`
4. Ensure all prerequisites are installed

## License

This software is proprietary. Unauthorized distribution is prohibited.

## Credits

Developed with Laravel, Python, FFmpeg, and MoviePy.