<?php
/**
 * UPDATE THIS FILE ON YOUR OTHER SYSTEM (C:\xampp\htdocs\public_html\...)
 * 
 * File Location: app/Http/Controllers/ImageGenerationController.php
 * 
 * TWO CHANGES NEEDED:
 * 
 * CHANGE 1: Replace the openImage() method (around line 269)
 * CHANGE 2: Wrap the image processing loop in try-catch (around line 167-227)
 */

// ============================================================================
// CHANGE 1: Replace openImage() method (around line 269)
// ============================================================================

private function openImage($path)
{
    if (!file_exists($path)) {
        \Log::error('Image file not found: ' . $path);
        throw new \Exception('Image file not found: ' . $path);
    }

    $info = getimagesize($path);
    if ($info === false) {
        throw new \Exception('Invalid image file: ' . $path);
    }
    
    $mime = $info['mime'];

    switch ($mime) {
        case 'image/jpeg':
            return imagecreatefromjpeg($path);
        case 'image/png':
            return imagecreatefrompng($path);
        case 'image/gif':
            return imagecreatefromgif($path);
        default:
            throw new \Exception('Unsupported image type: ' . $mime);
    }
}

// ============================================================================
// CHANGE 2: Wrap image processing in try-catch (in executeTask method)
// ============================================================================

// Find this code (around line 167):
//     foreach ($frontimages as $fi) {
//         $frontpath = public_path('img/user_template/' . $fi->customer_template);
//         $background = $this->openImage($backgroundpath);
//         $front = $this->openImage($frontpath);

// Replace it with:
//     foreach ($frontimages as $fi) {
//         try {
//             $frontpath = public_path('img/user_template/' . $fi->customer_template);
//             $background = $this->openImage($backgroundpath);
//             $front = $this->openImage($frontpath);

// Then find this code (around line 226):
//             imagejpeg($background, $outputPath, 100);
//         }
//         BeforeGenerate::where('id', $td->id)->update(['status' => false]);

// Replace it with:
//             imagejpeg($background, $outputPath, 100);
//         } catch (\Exception $e) {
//             // Log individual image error but continue processing others
//             \Log::warning("Failed to generate image for customer {$fi->customer_id}: " . $e->getMessage());
//             
//             $errorlog = new Errorlogs();
//             $errorlog->task_id = $id;
//             $errorlog->message = "Customer {$fi->customer_id}: " . $e->getMessage();
//             $errorlog->save();
//             
//             continue; // Skip this image and continue with next one
//         }
//     }
//     BeforeGenerate::where('id', $td->id)->update(['status' => false]);

/**
 * INSTRUCTIONS:
 * 
 * 1. Copy the openImage() method above
 * 2. On your other system, open: app/Http/Controllers/ImageGenerationController.php
 * 3. Find the existing openImage() method (around line 269)
 * 4. Replace it with the code above
 * 5. Save the file
 * 
 * WHAT THIS FIXES:
 * - Adds file existence check before trying to open image
 * - Logs the exact path when file is not found
 * - Shows clear error message with the missing file path
 * 
 * ============================================================================
 * ERROR FOUND ON YOUR OTHER SYSTEM:
 * ============================================================================
 * 
 * The file is missing:
 * C:\xampp\htdocs\public_html\public_html\public\img/user_template/user_template_1765097019_69353e3bb83e1.png
 * 
 * FIX OPTIONS:
 * 
 * Option 1: CHECK IF FILE EXISTS IN DIFFERENT LOCATION
 * Run this command on your other system to find the file:
 *   dir /s "user_template_1765097019_69353e3bb83e1.png"
 * 
 * Option 2: VERIFY YOUR DIRECTORY STRUCTURE
 * Your code expects files in: C:\xampp\htdocs\public_html\public_html\public\img\user_template\
 * 
 * Check if you have these folders:
 *   C:\xampp\htdocs\public_html\public_html\public\img\background_image\
 *   C:\xampp\htdocs\public_html\public_html\public\img\user_template\
 *   C:\xampp\htdocs\public_html\public_html\public\img\generated_image\
 * 
 * If they don't exist, create them OR copy files from your old system.
 * 
 * Option 3: COPY FILES FROM THIS SYSTEM (D:\xamp\...)
 * Copy these folders to your other system:
 *   FROM: D:\xamp\htdocs\imgen\public_html\public_html\public\img\user_template\
 *   TO:   C:\xampp\htdocs\public_html\public_html\public\img\user_template\
 * 
 *   FROM: D:\xamp\htdocs\imgen\public_html\public_html\public\img\background_image\
 *   TO:   C:\xampp\htdocs\public_html\public_html\public\img\background_image\
 */
?>
