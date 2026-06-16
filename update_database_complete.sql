-- 1. Create 'task' table if it doesn't exist
CREATE TABLE IF NOT EXISTS `task` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `taskname` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Add 'task_type' column safely (only if it's missing)
-- Note: MySQL doesn't support "IF NOT EXISTS" for columns directly, so we run a simple ALTER.
-- If the column already exists, this command might give a "Duplicate column" error, which is safe to ignore.
-- OR, you can run this specific block:

SELECT count(*) INTO @exist 
FROM information_schema.columns 
WHERE table_schema = DATABASE() 
AND table_name = 'task' 
AND column_name = 'task_type';

SET @query = IF(@exist <= 0, 
    'ALTER TABLE `task` ADD COLUMN `task_type` VARCHAR(50) NOT NULL DEFAULT "image" AFTER `id`', 
    'SELECT "Column task_type already exists"');

PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


-- 3. Create 'video_tasks' table if it doesn't exist (Required for video generation)
CREATE TABLE IF NOT EXISTS `video_tasks` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `task_id` bigint(20) unsigned NOT NULL,
  `video_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
