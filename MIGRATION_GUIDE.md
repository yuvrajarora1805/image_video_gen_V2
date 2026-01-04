# MIGRATION GUIDE - Update Old System to New Version

## Step 1: Backup Old System
Before doing anything, backup your old system's database:
```bash
mysqldump -u username -p database_name > backup_before_migration.sql
```

## Step 2: Copy Code Files
Copy these files from THIS system to the OLD system:

### Controllers:
- `app/Http/Controllers/InstagramController.php`

### Views:
- `resources/views/instagram/master-uploader.blade.php`
- `resources/views/instagram/credentials.blade.php` (if exists)

### Python Scripts:
- `video_generator.py`
- `facebook_uploader.py`
- `instagram_uploader.py`

### Routes:
- `routes/web.php` (merge the Instagram routes section)

### Models (if needed):
- `app/Models/InstagramCredential.php`
- `app/Models/InstagramUploadLog.php`

## Step 3: Run Database Migration
On the OLD system, run the SQL migration:
```bash
mysql -u username -p database_name < database_migration.sql
```

This will:
- ✅ Create new tables (instagram_credentials, instagram_upload_logs)
- ✅ Add new columns to existing tables
- ✅ Skip if tables/columns already exist
- ✅ Preserve all existing data

## Step 4: Clear Cache
```bash
cd /path/to/old/system
php artisan cache:clear
php artisan config:clear
php artisan view:clear
php artisan route:clear
```

## Step 5: Test
1. Login to the old system
2. Go to Instagram Credentials page
3. Add a test credential
4. Try uploading a video from Master Uploader

## What's New in This Version:
- ✅ Master Instagram Uploader (upload to multiple customers at once)
- ✅ Per-customer platform selection (IG/FB/Both)
- ✅ Per-customer default captions
- ✅ Search and filter customers
- ✅ Improved video quality (CRF 18, source FPS)
- ✅ Better error handling and logging
- ✅ File existence validation (no more 404 errors)

## Troubleshooting:
If you get errors about missing columns, manually check the migration:
```sql
SHOW COLUMNS FROM users LIKE 'default_upload_platform';
SHOW TABLES LIKE 'instagram_credentials';
```

If tables don't exist, run the migration again.
