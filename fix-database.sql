-- Complete Database Structure Fix for Laravel Image Generator
-- Run this file: mysql -u root laravel < fix-database.sql

USE laravel;

-- Fix customers table
ALTER TABLE customers 
    MODIFY email VARCHAR(100) NULL,
    MODIFY mobile VARCHAR(10) NULL;

-- Fix templates table
ALTER TABLE templates 
    MODIFY path VARCHAR(500);

-- Fix templates_by_user table
ALTER TABLE templates_by_user 
    MODIFY template_path VARCHAR(500);

-- Fix generated_image table - add missing taskid column
ALTER TABLE generated_image 
    ADD COLUMN IF NOT EXISTS taskid INT(11) AFTER id,
    MODIFY genarted_path VARCHAR(500);

-- Fix task table - ensure all required columns exist
ALTER TABLE task 
    ADD COLUMN IF NOT EXISTS sent_status TINYINT(1) DEFAULT 0 AFTER status,
    ADD COLUMN IF NOT EXISTS finished_at TIMESTAMP NULL AFTER sent_status,
    ADD COLUMN IF NOT EXISTS is_active TINYINT(1) DEFAULT 1 AFTER finished_at;

-- Fix before_genration table - ensure backgroundpath exists
ALTER TABLE before_genration 
    ADD COLUMN IF NOT EXISTS backgroundpath VARCHAR(500) AFTER backgroundimage;

-- Show final structures
SELECT 'Customers Table:' as '';
DESCRIBE customers;

SELECT 'Templates Table:' as '';
DESCRIBE templates;

SELECT 'Templates By User Table:' as '';
DESCRIBE templates_by_user;

SELECT 'Generated Image Table:' as '';
DESCRIBE generated_image;

SELECT 'Task Table:' as '';
DESCRIBE task;

SELECT 'Before Generation Table:' as '';
DESCRIBE before_genration;

SELECT 'Database structure updated successfully!' as 'Status';
