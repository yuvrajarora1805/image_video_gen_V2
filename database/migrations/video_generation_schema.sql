-- Video Generation Database Schema
-- Add these tables to support video generation feature

-- Table for master video templates (background videos)
CREATE TABLE `video_templates` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `video_type` enum('portrait','landscape') NOT NULL DEFAULT 'portrait',
  `path` varchar(500) NOT NULL,
  `video_file` varchar(255) NOT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL COMMENT 'Duration in seconds',
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table for customer videos assigned to master templates
CREATE TABLE `videos_by_user` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `master_video_id` bigint(20) UNSIGNED NOT NULL,
  `customer_video` varchar(255) NOT NULL,
  `video_path` varchar(500) NOT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `master_video_id` (`master_video_id`),
  CONSTRAINT `videos_by_user_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE,
  CONSTRAINT `videos_by_user_master_video_id_foreign` FOREIGN KEY (`master_video_id`) REFERENCES `video_templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table for generated videos
CREATE TABLE `generated_videos` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `taskid` int(11) NOT NULL,
  `beforeid` int(11) DEFAULT NULL,
  `customer_id` bigint(20) UNSIGNED NOT NULL,
  `master_video_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_video_id` bigint(20) UNSIGNED DEFAULT NULL,
  `generated_path` varchar(500) NOT NULL,
  `generated_video` varchar(255) NOT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `video_type` enum('portrait','landscape') NOT NULL DEFAULT 'portrait',
  `duration` int(11) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL COMMENT 'Size in bytes',
  `sent` tinyint(1) NOT NULL DEFAULT 0,
  `sent_date` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `taskid` (`taskid`),
  KEY `customer_id` (`customer_id`),
  KEY `master_video_id` (`master_video_id`),
  KEY `user_video_id` (`user_video_id`),
  CONSTRAINT `generated_videos_customer_id_foreign` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add video support to before_genration table
ALTER TABLE `before_genration` 
ADD COLUMN `content_type` enum('image','video') NOT NULL DEFAULT 'image' AFTER `taskid`,
ADD COLUMN `video_type` enum('portrait','landscape') NULL DEFAULT NULL AFTER `content_type`;

-- Add video support to task table
ALTER TABLE `task` 
ADD COLUMN `task_type` enum('image','video') NOT NULL DEFAULT 'image' AFTER `taskname`;
