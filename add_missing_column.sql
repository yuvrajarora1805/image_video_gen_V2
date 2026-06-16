-- Add task_type column if it doesn't exist
-- Run this in PHPMyAdmin

ALTER TABLE `task` 
ADD COLUMN `task_type` VARCHAR(50) NOT NULL DEFAULT 'image' AFTER `id`;

-- Update existing records to be 'image' by default
UPDATE `task` SET `task_type` = 'image' WHERE `task_type` IS NULL;
