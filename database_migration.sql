-- ============================================================
-- DATABASE MIGRATION SCRIPT
-- Safe to run on existing database - won't delete any data
-- Creates new tables and columns only if they don't exist
-- ============================================================

-- Add default_upload_platform to users table (if not exists)
ALTER TABLE `users` 
ADD COLUMN IF NOT EXISTS `default_upload_platform` ENUM('instagram', 'facebook', 'both') DEFAULT 'instagram' AFTER `remember_token`;

-- Create instagram_credentials table (if not exists)
CREATE TABLE IF NOT EXISTS `instagram_credentials` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `customer_id` bigint(20) UNSIGNED DEFAULT NULL,
  `credential_name` varchar(255) NOT NULL,
  `access_token` text NOT NULL,
  `ig_user_id` varchar(255) DEFAULT NULL,
  `page_id` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instagram_credentials_user_id_foreign` (`user_id`),
  KEY `instagram_credentials_customer_id_foreign` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create instagram_upload_logs table (if not exists)
CREATE TABLE IF NOT EXISTS `instagram_upload_logs` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `credential_id` bigint(20) UNSIGNED NOT NULL,
  `video_path` varchar(500) NOT NULL,
  `video_url` varchar(500) DEFAULT NULL,
  `caption` text DEFAULT NULL,
  `platform` enum('instagram','facebook','both') DEFAULT 'instagram',
  `status` enum('pending','processing','published','failed') DEFAULT 'pending',
  `instagram_media_id` varchar(255) DEFAULT NULL,
  `facebook_video_id` varchar(255) DEFAULT NULL,
  `error_message` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `instagram_upload_logs_user_id_foreign` (`user_id`),
  KEY `instagram_upload_logs_credential_id_foreign` (`credential_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add customer_id to instagram_credentials if not exists
ALTER TABLE `instagram_credentials`
ADD COLUMN IF NOT EXISTS `customer_id` bigint(20) UNSIGNED DEFAULT NULL AFTER `user_id`,
ADD KEY IF NOT EXISTS `instagram_credentials_customer_id_foreign` (`customer_id`);

-- Add page_id to instagram_credentials if not exists  
ALTER TABLE `instagram_credentials`
ADD COLUMN IF NOT EXISTS `page_id` varchar(255) DEFAULT NULL AFTER `ig_user_id`;

-- Add platform to instagram_upload_logs if not exists
ALTER TABLE `instagram_upload_logs`
ADD COLUMN IF NOT EXISTS `platform` enum('instagram','facebook','both') DEFAULT 'instagram' AFTER `caption`;

-- ============================================================
-- MIGRATION COMPLETE
-- All new tables and columns have been added safely
-- Existing data has been preserved
-- ============================================================
