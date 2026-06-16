-- Run this on your LIVE SERVER database (C:\xampp machine)
-- This fixes the "Column not found: task_type" error

ALTER TABLE `task` 
ADD COLUMN `task_type` ENUM('image','video') NOT NULL DEFAULT 'image' AFTER `taskname`;

-- Also ensure 'type' exists as it seems to be used interchangeably in some versions
-- ALTER TABLE `task` ADD COLUMN `type` ENUM('image','video') NOT NULL DEFAULT 'image' AFTER `taskname`;

-- Ensure is_active exists
-- ALTER TABLE `task` ADD COLUMN `is_active` TINYINT(1) DEFAULT 1;
