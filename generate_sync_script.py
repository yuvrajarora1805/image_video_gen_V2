
import re

def generate_smart_sync(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        sql_content = f.read()

    # Regex to find CREATE TABLE blocks
    table_pattern = re.compile(r'CREATE TABLE `(\w+)` \((.*?)\) ENGINE=.*?;', re.DOTALL)
    
    smart_sql = []
    smart_sql.append("-- SMART DATABASE SYNC SCRIPT")
    smart_sql.append("-- Generated from Golden Schema")
    smart_sql.append("-- This script adds missing tables and columns safely.")
    smart_sql.append("")

    for match in table_pattern.finditer(sql_content):
        table_name = match.group(1)
        columns_block = match.group(2)
        
        # 1. Generate CREATE TABLE IF NOT EXISTS
        create_stmt = f"CREATE TABLE IF NOT EXISTS `{table_name}` ({columns_block}) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;"
        smart_sql.append(f"-- Syncing table: {table_name}")
        smart_sql.append(create_stmt)
        
        # 2. Parse columns to generate ADD COLUMN IF NOT EXISTS logic
        # Simple extraction of column definitions
        lines = columns_block.split('\n')
        for line in lines:
            line = line.strip().rstrip(',')
            if not line or line.startswith('PRIMARY KEY') or line.startswith('KEY') or line.startswith('CONSTRAINT') or line.startswith('UNIQUE'):
                continue
            
            # Extract column name
            col_match = re.match(r'`(\w+)`', line)
            if col_match:
                col_name = col_match.group(1)
                col_def = line  # Full definition line
                
                # Create a stored procedure block for safe column addition
                proc_block = f"""
SET @dbname = DATABASE();
SET @tablename = '{table_name}';
SET @columnname = '{col_name}';
SET @preparedStatement = (SELECT IF(
  (
    SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
    WHERE
      (table_name = @tablename)
      AND (table_schema = @dbname)
      AND (column_name = @columnname)
  ) > 0,
  "SELECT 1",
  "ALTER TABLE `{table_name}` ADD {col_def}"
));
PREPARE stmt FROM @preparedStatement;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;"""
                smart_sql.append(proc_block)

        smart_sql.append("")

    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(smart_sql))

    print(f"✅ Generated {output_file}")

if __name__ == "__main__":
    generate_smart_sync('full_golden_schema.sql', 'smart_db_sync.sql')
