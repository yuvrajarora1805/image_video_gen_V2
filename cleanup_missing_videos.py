#!/usr/bin/env python3
"""
Cleanup Script - Mark Missing Videos as Sent
Finds all video records in database where the actual file doesn't exist
and marks them as sent=1 so they don't appear in the uploader
"""

import os
import sys

# Add Laravel project to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

def cleanup_missing_videos():
    """Find and mark missing videos as sent"""
    
    # Import after adding to path
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    
    # Use PHP to query database and check files
    php_script = """
    <?php
    require 'vendor/autoload.php';
    $app = require_once 'bootstrap/app.php';
    $kernel = $app->make(Illuminate\\Contracts\\Console\\Kernel::class);
    $kernel->bootstrap();
    
    $videos = \\App\\Models\\GeneratedVideo::where('sent', 0)->get();
    $missing = [];
    $existing = [];
    
    foreach ($videos as $video) {
        $path = public_path('videos/generated_video/' . $video->generated_video);
        if (!file_exists($path)) {
            $missing[] = [
                'id' => $video->id,
                'filename' => $video->generated_video,
                'customer_id' => $video->customer_id
            ];
        } else {
            $existing[] = $video->generated_video;
        }
    }
    
    echo "MISSING:" . count($missing) . "\\n";
    echo "EXISTING:" . count($existing) . "\\n";
    
    if (count($missing) > 0) {
        echo "\\nMissing videos:\\n";
        foreach ($missing as $m) {
            echo "  ID: " . $m['id'] . " - " . $m['filename'] . "\\n";
        }
        
        // Mark as sent
        $ids = array_column($missing, 'id');
        \\App\\Models\\GeneratedVideo::whereIn('id', $ids)->update(['sent' => 1]);
        
        echo "\\n✅ Marked " . count($missing) . " missing videos as sent\\n";
    } else {
        echo "\\n✅ No missing videos found!\\n";
    }
    ?>
    """
    
    # Write temp PHP file
    with open('temp_cleanup.php', 'w') as f:
        f.write(php_script)
    
    # Execute
    import subprocess
    result = subprocess.run(['php', 'temp_cleanup.php'], capture_output=True, text=True)
    
    print(result.stdout)
    if result.stderr:
        print("Errors:", result.stderr)
    
    # Cleanup temp file
    os.remove('temp_cleanup.php')
    
    return result.returncode == 0

if __name__ == "__main__":
    print("="*60)
    print("VIDEO DATABASE CLEANUP")
    print("="*60)
    print("\nSearching for videos in database that don't exist on disk...")
    print()
    
    success = cleanup_missing_videos()
    
    print()
    print("="*60)
    if success:
        print("✅ Cleanup completed!")
        print("Refresh the master uploader page - missing videos won't show anymore")
    else:
        print("❌ Cleanup failed - check errors above")
    print("="*60)
    
    sys.exit(0 if success else 1)
