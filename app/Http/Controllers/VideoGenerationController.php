<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\VideoTemplate;
use App\Models\VideosByUser;
use App\Models\GeneratedVideo;
use App\Models\Customer;
use App\Models\Task;
use App\Models\BeforeGenerate;
use App\Models\TemplatesByUser;
use App\Models\Tempstore;
use App\Models\Logs;
use App\Models\Errorlogs;
use App\Services\VideoProcessor;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

class VideoGenerationController extends Controller
{
    private $videoProcessor;

    public function __construct()
    {
        $this->videoProcessor = new VideoProcessor();
    }

    // SECTION 1: Video Template Management
    
    public function showVideoTemplates(Request $request)
    {
        if ($request->ajax()) {
            $query = VideoTemplate::withUserCount();

            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where('name', 'LIKE', "%$search%");
            }

            $templates = $query->orderBy('id', 'DESC')->paginate(50);

            if ($templates->getCollection()) {
                $templates->getCollection()->transform(function ($template) {
                    $template->formatted_date = \Carbon\Carbon::parse($template->created_at)->format('d-m-Y - H:i A');
                    return $template;
                });
            }

            return response()->json([
                'data' => $templates->items(),
                'pagination' => $templates->appends(request()->input())->links()->render()
            ]);
        } else {
            // For non-AJAX requests, pass templates to view
            $templates = VideoTemplate::orderBy('id', 'DESC')->paginate(20);
            return view('video.templates', compact('templates'));
        }
    }

    public function showCreateVideoTemplateForm()
    {
        return view('video.create-template');
    }

    public function uploadVideoTemplate(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'video_type' => 'required|in:portrait,landscape',
            'image_file' => 'required|file|mimes:jpeg,jpg,png|max:10240' // 10MB max for template image
        ]);

        try {
            DB::beginTransaction();

            // Check if template with same name already exists
            $existingTemplate = VideoTemplate::where('name', $request->name)->first();
            if ($existingTemplate) {
                DB::rollBack();
                
                if ($request->ajax()) {
                    return response()->json(['success' => false, 'message' => $request->name . ' Video template already exists.'], 400);
                }
                return redirect()->back()->with('error', $request->name . ' Video template already exists.');
            }

            $imageFile = $request->file('image_file');
            $fileName = 'video_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
            $path = public_path('img/master_template');
            
            // Ensure directory exists
            if (!file_exists($path)) {
                mkdir($path, 0777, true);
            }
            
            $imageFile->move($path, $fileName);

            $template = new VideoTemplate();
            $template->name = $request->name;
            $template->video_type = $request->video_type;
            $template->image_path = $fileName;
            $template->path = 'img/master_template/' . $fileName;
            $template->video_file = $fileName;
            $template->is_active = 1;
            $template->save();

            // Log success
            $logs = new \App\Models\Logs();
            $logs->task_id = $template->id;
            $logs->status = 'success';
            $logs->message = 'Video template created successfully';
            $logs->save();

            DB::commit();

            if ($request->ajax()) {
                return response()->json(['success' => true, 'message' => 'Video template created successfully']);
            }
            return redirect()->route('video-template-form')->with('success', 'Video template created successfully');
        } catch (\Exception $e) {
            DB::rollBack();
            
            $errorlogs = new \App\Models\Errorlogs();
            $errorlogs->action = 'Video Template Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();
            
            if ($request->ajax()) {
                return response()->json(['success' => false, 'message' => 'Error: ' . $e->getMessage()], 500);
            }
            return redirect()->back()->with('error', 'Error: ' . $e->getMessage());
        }
    }

    public function deleteVideoTemplate($id)
    {
        try {
            DB::beginTransaction();

            $template = VideoTemplate::findOrFail($id);
            
            // Check if template is being used
            $usageCount = TemplatesByUser::where('master_template_id', $id)
                ->where('content_type', 'video')
                ->count();
            
            if ($usageCount > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete template. It is assigned to ' . $usageCount . ' customer(s).'
                ], 400);
            }

            // Delete image file
            $imagePath = public_path('img/master_template/' . $template->image_path);
            if (File::exists($imagePath)) {
                File::delete($imagePath);
            }

            $template->delete();

            DB::commit();

            return response()->json(['success' => true, 'message' => 'Video template deleted successfully']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['success' => false, 'message' => 'Error: ' . $e->getMessage()], 500);
        }
    }

    // SECTION 2: Customer Video Assignment

    public function showAssignVideos()
    {
        $customers = Customer::orderBy('id', 'desc')->get();
        $templates = VideoTemplate::orderBy('id', 'desc')->get();
        $assignedVideos = VideosByUser::with(['customer', 'videoTemplate'])
            ->orderBy('id', 'desc')
            ->paginate(20);
        
        return view('video.assign', compact('customers', 'templates', 'assignedVideos'));
    }

    public function assignVideoToCustomer(Request $request)
    {
        $request->validate([
            'customer_id' => 'required|exists:customers,id',
            'video_template_id' => 'required|exists:video_templates,id',
            'customer_video' => 'required|file|mimes:mp4,mov,avi,wmv|max:512000'
        ]);

        try {
            DB::beginTransaction();

            $videoFile = $request->file('customer_video');
            $fileName = 'customer_' . time() . '_' . uniqid() . '.' . $videoFile->getClientOriginalExtension();
            $path = public_path('videos/user_template');
            $videoFile->move($path, $fileName);

            $fullPath = $path . '/' . $fileName;

            // Get video info
            $videoInfo = $this->videoProcessor->getVideoInfo($fullPath);

            // Generate thumbnail
            $thumbnailName = 'thumb_' . pathinfo($fileName, PATHINFO_FILENAME) . '.jpg';
            $thumbnailPath = public_path('videos/thumbnails/' . $thumbnailName);
            $this->videoProcessor->generateThumbnail($fullPath, $thumbnailPath);

            $videoByUser = new VideosByUser();
            $videoByUser->customerid = $request->customer_id;
            $videoByUser->video_template_id = $request->video_template_id;
            $videoByUser->video_path = $fileName;
            $videoByUser->thumbnail_path = $thumbnailName;
            $videoByUser->duration = $videoInfo['duration'] ?? 0;
            $videoByUser->size = filesize($fullPath);
            $videoByUser->save();

            DB::commit();

            return response()->json(['success' => true, 'message' => 'Customer video assigned successfully']);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['success' => false, 'message' => 'Error: ' . $e->getMessage()], 500);
        }
    }

    // SECTION 3: Video Generation Task Management

    public function showGenerateVideos()
    {
        $tasks = Task::select('task.*')
            ->where('task.task_type', 'video')
            ->where('task.is_active', 1)
            ->orderBy('task.id', 'desc')
            ->paginate(50);

        // Add counts to each task (mirror ImageGenerationController)
        foreach ($tasks as $task) {
            // Count expected videos (from before_genration and templates_by_user)
        $totalExpected = DB::table('before_genration as bg')
            ->leftJoin('templates_by_user as tu', function($join) {
                $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                     ->where('tu.content_type', '=', 'video');
            })
            ->where('bg.taskid', $task->id)
            ->where('bg.content_type', 'video')
            ->count('tu.id');
            
            // Count generated videos
            $generated = DB::table('generated_videos')
                ->where('taskid', $task->id)
                ->selectRaw('COUNT(*) as total, SUM(CASE WHEN sent = 1 THEN 1 ELSE 0 END) as sent_count, SUM(CASE WHEN sent = 0 THEN 1 ELSE 0 END) as pending_count')
                ->first();
            
            $task->totalvideos = max($totalExpected, $generated->total ?? 0);
            $task->generated_count = $generated->total ?? 0;
            $task->send = $generated->sent_count ?? 0;
            $task->pending = $generated->pending_count ?? 0;
            
            // Calculate percentage for progress bar
            $totalGen = $generated->total ?? 0;
            $task->percentage = $task->totalvideos > 0 ? round(($totalGen / $task->totalvideos) * 100) : 0;
        }

        return view('video.generate', compact('tasks'));
    }

    public function createVideoTask(Request $request)
    {
        $request->validate([
            'master_video_id' => 'required|exists:video_templates,id',
            'background_video' => 'required|file|mimes:mp4,mov,avi,wmv|max:512000'
        ]);

        try {
            DB::beginTransaction();

            $taskCount = Task::where('task_type', 'video')->count();
            $nextTaskNumber = $taskCount + 1;

            $task = new Task();
            $task->taskname = 'VideoTask' . sprintf('%02d', $nextTaskNumber);
            $task->task_type = 'video';
            $task->remark = 'Pending';
            $task->save();

            // Upload background video
            $videoFile = $request->file('background_video');
            $fileName = 'bg_' . time() . '.' . $videoFile->getClientOriginalExtension();
            $path = public_path('videos/master_template');
            $videoFile->move($path, $fileName);

            $fullPath = $path . '/' . $fileName;

            // Get video template info
            $template = VideoTemplate::find($request->master_video_id);

            $beforeGeneration = new BeforeGenerate();
            $beforeGeneration->mastertemplateid = $request->master_video_id;
            $beforeGeneration->backgroundimage = $fileName;
            $beforeGeneration->backgroundpath = $fullPath;
            $beforeGeneration->taskid = $task->id;
            $beforeGeneration->content_type = 'video';
            $beforeGeneration->video_type = $template->video_type;
            $beforeGeneration->status = 1;
            $beforeGeneration->save();

            DB::commit();

            return response()->json(['success' => true, 'task_name' => $task->taskname]);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['success' => false, 'message' => 'Error: ' . $e->getMessage()], 500);
        }
    }

    public function executeVideoTask($id)
    {
        // Return immediately to avoid Cloudflare timeout
        // All processing happens in background queue
        
        DB::beginTransaction();

        try {
            $task = Task::find($id);

            if (!$task) {
                return response()->json(['success' => false, 'message' => 'Task not found'], 404);
            }

            if ($task->status != 0) {
                return response()->json(['success' => true, 'message' => 'Task already processing or completed']);
            }

            // Mark task as processing
            $task->status = 2; // Processing
            $task->save();

            DB::commit();

            // Dispatch task processing to queue (runs in background)
            \App\Jobs\ProcessVideoTaskJob::dispatch($id)->onQueue('video_cpu');

            // Auto-start workers if none running
            $this->ensureWorkersRunning();

            \Log::info("Task {$id} dispatched to queue for processing");

            return response()->json([
                'success' => true, 
                'message' => 'Task queued for processing. Videos will be generated in background.'
            ]);

        } catch (\Exception $e) {
            DB::rollBack();
            \Log::error("Failed to queue task {$id}: " . $e->getMessage());
            
            return response()->json([
                'success' => false, 
                'message' => 'Failed to queue task: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Generate video using Python script with animated.py logic
     */
    private function generateVideoWithPython($backgroundVideoPath, $templatePath, $outputPath, $animationEffect = 'wipe-in')
    {
        try {
            $pythonScript = base_path('video_generator.py');
            
            if (!file_exists($pythonScript)) {
                throw new \Exception("Python script not found: {$pythonScript}");
            }
            
            // Convert paths to absolute paths with proper formatting
            $bgVideo = str_replace('/', '\\', $backgroundVideoPath);
            $template = str_replace('/', '\\', $templatePath);
            $output = str_replace('/', '\\', $outputPath);

            // Build the command - include animation effect as 4th parameter
            // Use full Python path since it's not in system PATH
            $pythonPath = env('PYTHON_PATH', 'python');
            
            // Prepare environment variables for FFmpeg
            $envPrefix = '';
            $ffmpegPath = env('FFMPEG_PATH');
            if ($ffmpegPath && file_exists($ffmpegPath)) {
                $ffmpegDir = dirname($ffmpegPath);
                $envPrefix = "set PATH={$ffmpegDir};%PATH% && set IMAGEIO_FFMPEG_EXE={$ffmpegPath} && ";
            }

            $command = sprintf(
                '%s"%s" "%s" "%s" "%s" "%s" "%s" 2>&1',
                $envPrefix,
                $pythonPath,
                $pythonScript,
                $bgVideo,
                $template,
                $output,
                $animationEffect
            );

            \Log::info("Executing Python command: {$command}");
            \Log::info("Animation effect: {$animationEffect}");

            // Execute the command
            exec($command, $outputLines, $returnCode);
            $outputData = implode("\n", $outputLines);

            \Log::info("Python script output: {$outputData}");
            \Log::info("Python script return code: {$returnCode}");

            if ($returnCode !== 0) {
                throw new \Exception("Python script failed with code {$returnCode}: {$outputData}");
            }

            // Check if file was created
            if (!file_exists($outputPath)) {
                return [
                    'success' => false,
                    'error' => 'Video file was not created. Output: ' . $outputData
                ];
            }

            // Get video duration from output
            $duration = null;
            if (preg_match('/Duration: ([\d.]+)/', $outputData, $matches)) {
                $duration = floatval($matches[1]);
            }

            return [
                'success' => true,
                'duration' => $duration,
                'output' => $outputData
            ];

        } catch (\Exception $e) {
            \Log::error("Error in generateVideoWithPython: " . $e->getMessage());
            return [
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }

    /**
     * Generate multiple videos in parallel using Python multiprocessing
     */
    private function generateVideosInParallel($videoBatch)
    {
        try {
            $pythonScript = base_path('parallel_video_generator.py');
            
            if (!file_exists($pythonScript)) {
                throw new \Exception("Parallel video generator script not found: {$pythonScript}");
            }
            
            // Convert batch to JSON
            $jsonTasks = json_encode($videoBatch);
            
            // Escape JSON for command line
            $escapedJson = str_replace('"', '\"', $jsonTasks);
            
            // Prepare environment variables for FFmpeg
            $envPrefix = '';
            $ffmpegPath = env('FFMPEG_PATH');
            if ($ffmpegPath && file_exists($ffmpegPath)) {
                $ffmpegDir = dirname($ffmpegPath);
                $envPrefix = "set PATH={$ffmpegDir};%PATH% && set IMAGEIO_FFMPEG_EXE={$ffmpegPath} && ";
            }
            
            // Determine Python Path safely
            $pythonPath = env('PYTHON_PATH', 'python');
            
            // Check if GPU is enabled from settings or env
            $settingsPath = storage_path('app/gpu_settings.json');
            $gpuEnabled = '1'; // Default
            if (file_exists($settingsPath)) {
                $settings = json_decode(file_get_contents($settingsPath), true);
                $gpuEnabled = ($settings['enabled'] ?? true) ? '1' : '0';
            } else {
                $gpuEnabled = env('USE_GPU', '1');
            }
            
            // Build command with GPU setting as environment variable
            $command = sprintf(
                '%sset USE_GPU=%s && "%s" "%s" "%s" 2>&1',
                $envPrefix,
                $gpuEnabled,
                $pythonPath,
                $pythonScript,
                $escapedJson
            );
            
            \Log::info("Executing parallel video generation for " . count($videoBatch) . " videos");
            \Log::info("GPU Acceleration: " . ($gpuEnabled === '1' ? 'Enabled' : 'Disabled'));
            
            // Execute command
            exec($command, $outputLines, $returnCode);
            $outputData = implode("\n", $outputLines);
            
            \Log::info("Parallel script output: {$outputData}");
            
            // Parse JSON results from output
            $results = [];
            $jsonStarted = false;
            $jsonLines = [];
            
            foreach ($outputLines as $line) {
                if (strpos($line, 'RESULTS_JSON_START') !== false) {
                    $jsonStarted = true;
                    continue;
                }
                if (strpos($line, 'RESULTS_JSON_END') !== false) {
                    break;
                }
                if ($jsonStarted) {
                    $jsonLines[] = $line;
                }
            }
            
            if (!empty($jsonLines)) {
                $jsonString = implode("\n", $jsonLines);
                $results = json_decode($jsonString, true);
                
                if (json_last_error() !== JSON_ERROR_NONE) {
                    throw new \Exception("Failed to parse results JSON: " . json_last_error_msg());
                }
            } else {
                // If no JSON results, create error results for all videos
                foreach ($videoBatch as $index => $video) {
                    $results[] = [
                        'success' => false,
                        'index' => $index,
                        'error' => 'No results returned from parallel script'
                    ];
                }
            }
            
            return $results;
            
        } catch (\Exception $e) {
            \Log::error("Error in generateVideosInParallel: " . $e->getMessage());
            
            // Return error results for all videos
            $results = [];
            foreach ($videoBatch as $index => $video) {
                $results[] = [
                    'success' => false,
                    'index' => $index,
                    'error' => $e->getMessage()
                ];
            }
            return $results;
        }
    }


    /**
     * Generate thumbnail from video
     */
    private function generateThumbnail($videoPath, $thumbnailPath)
    {
        try {
            // Ensure thumbnails directory exists
            $thumbnailDir = dirname($thumbnailPath);
            if (!file_exists($thumbnailDir)) {
                mkdir($thumbnailDir, 0777, true);
            }

            // Use FFmpeg to generate thumbnail at 1 second
            $command = sprintf(
                'ffmpeg -i "%s" -ss 00:00:01 -vframes 1 -q:v 2 "%s" 2>&1',
                str_replace('/', '\\', $videoPath),
                str_replace('/', '\\', $thumbnailPath)
            );

            exec($command, $output, $returnCode);

            if ($returnCode !== 0 || !file_exists($thumbnailPath)) {
                \Log::warning("Failed to generate thumbnail for {$videoPath}");
                return false;
            }

            return true;
        } catch (\Exception $e) {
            \Log::error("Thumbnail generation error: " . $e->getMessage());
            return false;
        }
    }

    // Show form to create video tasks
    public function showGenerateForm()
    {
        $templates = VideoTemplate::all();
        return view('video.form', compact('templates'));
    }

    // Get user details for a video template (mirror of ImageGenerationController)
    public function getUserDetails($masterTemplateId)
    {
        try {
            $totalUsers = TemplatesByUser::where('master_template_id', $masterTemplateId)
                ->where('content_type', 'video')
                ->count();
            
            return response()->json(['success' => true, 'totaluser' => $totalUsers]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // Get video template image for preview
    public function getVideoTemplateImage($id)
    {
        try {
            $template = VideoTemplate::findOrFail($id);
            $imagePath = asset('img/master_template/' . $template->image_path);
            return response()->json(['success' => true, 'imagePath' => $imagePath]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // Process temp data to create video task (mirror of ImageGenerationController)
    public function processVideoTempData(Request $request)
    {
        DB::beginTransaction();

        try {
            $tempData = Tempstore::where('content_type', 'video')->get();

            if ($tempData->isEmpty()) {
                throw new \Exception('No video data found in Tempstore');
            }

            $taskCount = Task::where('task_type', 'video')->count();
            $nextTaskNumber = $taskCount + 1;

            $task = new Task();
            $task->taskname = 'VideoTask' . sprintf('%02d', $nextTaskNumber);
            $task->task_type = 'video';
            $task->remark = 'Pending';
            $task->status = 0;
            $task->save();

            foreach ($tempData as $data) {
                $beforeGeneration = new BeforeGenerate();
                $beforeGeneration->mastertemplateid = $data->mastertemplateid;
                $beforeGeneration->backgroundimage = $data->backgroundimage;
                $beforeGeneration->backgroundpath = $data->backgroundpath;
                $beforeGeneration->taskid = $task->id;
                $beforeGeneration->content_type = 'video';
                $beforeGeneration->video_type = $data->video_type ?? 'landscape';
                $beforeGeneration->animation_effect = $data->animation_effect ?? 'wipe-in';
                $beforeGeneration->rendering_engine = $data->rendering_engine ?? 'ffmpeg';
                $beforeGeneration->status = 1;
                $beforeGeneration->save();
            }

            $logs = new Logs();
            $logs->task_id = $task->id;
            $logs->status = 'success';
            $logs->message = 'Video task created successfully';
            $logs->save();

            DB::commit();

            // Clear temp data for video content type only
            Tempstore::where('content_type', 'video')->delete();

            // Note: Workers will auto-start when task is executed (not here)
            // This keeps task creation instant

            return response()->json(['success' => true, 'task_name' => $task->taskname]);
        } catch (\Exception $e) {
            DB::rollBack();

            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Video Task Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();

            return response()->json(['success' => false, 'message' => 'No data found'], 400);
        }
    }

    // Get generated videos for a task
    public function getGeneratedVideos($taskId)
    {
        try {
            $videos = GeneratedVideo::where('taskid', $taskId)
                ->with(['customer'])
                ->orderBy('id', 'desc')
                ->get();
            
            $videoList = [];
            foreach ($videos as $video) {
                $videoList[] = [
                    'id' => $video->id,
                    'customer_name' => $video->customer ? $video->customer->name : 'Unknown',
                    'customer_email' => $video->customer ? $video->customer->email : '',
                    'customer_mobile' => $video->customer ? $video->customer->mobile : '',
                    'video_name' => $video->generated_video,
                    'video_url' => env('APP_URL') . '/imgen/public_html/public_html/public/videos/generated_video/' . $video->generated_video,
                    'thumbnail_url' => $video->thumbnail ? asset('videos/thumbnails/' . $video->thumbnail) : '',
                    'video_type' => $video->video_type,
                    'duration' => $video->duration,
                    'file_size' => $video->file_size ? round($video->file_size / 1024 / 1024, 2) . ' MB' : '',
                    'sent' => $video->sent,
                    'created_at' => $video->created_at->format('d M Y H:i')
                ];
            }
            
            return response()->json(['success' => true, 'videos' => $videoList]);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // Download a generated video
    public function downloadVideo($id)
    {
        try {
            $video = GeneratedVideo::findOrFail($id);
            $filePath = $video->generated_path;
            
            if (!file_exists($filePath)) {
                return response()->json(['success' => false, 'message' => 'Video file not found'], 404);
            }
            
            return response()->download($filePath, $video->generated_video);
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    // Download all videos in a task as ZIP
    public function downloadTaskVideos($taskId)
    {
        try {
            $task = Task::findOrFail($taskId);
            $videos = GeneratedVideo::with('customer')->where('taskid', $taskId)->get();
            
            if ($videos->isEmpty()) {
                return back()->with('error', 'No videos found for this task');
            }
            
            $zipFileName = 'videos_task_' . $taskId . '_' . date('YmdHis') . '.zip';
            $zipPath = storage_path('app/temp/' . $zipFileName);
            
            // Create temp directory if it doesn't exist
            if (!file_exists(storage_path('app/temp'))) {
                mkdir(storage_path('app/temp'), 0777, true);
            }
            
            $zip = new \ZipArchive();
            
            if ($zip->open($zipPath, \ZipArchive::CREATE | \ZipArchive::OVERWRITE) === true) {
                $addedCount = 0;
                foreach ($videos as $video) {
                    $videoPath = $video->generated_path ?? public_path('videos/generated_video/' . $video->generated_video);
                    
                    if (file_exists($videoPath)) {
                        // Get customer name safely
                        $customerName = 'customer_' . $video->customer_id;
                        if ($video->customer && $video->customer->name) {
                            $customerName = preg_replace('/[^A-Za-z0-9_\-]/', '_', $video->customer->name);
                        }
                        
                        $fileName = $customerName . '_' . basename($videoPath);
                        $zip->addFile($videoPath, $fileName);
                        $addedCount++;
                    } else {
                        \Log::warning("Video file not found: {$videoPath}");
                    }
                }
                $zip->close();
                
                if ($addedCount == 0) {
                    return back()->with('error', 'No video files found on disk');
                }
                
                \Log::info("Downloading ZIP with {$addedCount} videos for task {$taskId}");
                return response()->download($zipPath, $zipFileName)->deleteFileAfterSend(true);
            } else {
                return back()->with('error', 'Failed to create ZIP file');
            }
        } catch (\Exception $e) {
            \Log::error("Download failed for task {$taskId}: " . $e->getMessage());
            return back()->with('error', 'Download failed: ' . $e->getMessage());
        }
    }

    // GPU Management API
    
    public function getGpuStatus()
    {
        try {
            // Get user preference (default to true)
            $settingsPath = storage_path('app/gpu_settings.json');
            $enabled = true;
            
            if (file_exists($settingsPath)) {
                $settings = json_decode(file_get_contents($settingsPath), true);
                $enabled = $settings['enabled'] ?? true;
            }
            
            // Check hardware availability
            $python = env('PYTHON_PATH', 'python');
            $script = base_path('video_generator.py');
            
            $cmd = "\"{$python}\" \"{$script}\" --check-gpu";
            $output = shell_exec($cmd);
            $hardwareStatus = json_decode($output, true);
            
            if (!$hardwareStatus) {
                // Fallback if script fails
                $hardwareStatus = [
                    'available' => false,
                    'encoder' => null,
                    'message' => 'Failed to check GPU status'
                ];
            }
            
            return response()->json([
                'success' => true,
                'enabled' => $enabled,
                'available' => $hardwareStatus['available'],
                'encoder' => $hardwareStatus['encoder'],
                'message' => $hardwareStatus['message']
            ]);
            
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    
    public function toggleGpu()
    {
        try {
            $settingsPath = storage_path('app/gpu_settings.json');
            $current = true;
            
            if (file_exists($settingsPath)) {
                $settings = json_decode(file_get_contents($settingsPath), true);
                $current = $settings['enabled'] ?? true;
            }
            
            // Toggle
            $newState = !$current;
            file_put_contents($settingsPath, json_encode(['enabled' => $newState]));
            
            // Re-fetch full status to return
            return $this->getGpuStatus();
            
        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()]);
        }
    }
    
    // API to check task progress
    public function getTaskProgress($id)
    {
        try {
            $task = Task::find($id);
            if (!$task) {
                \Log::warning("Task not found: {$id}");
                return response()->json(['success' => false, 'message' => 'Task not found'], 404);
            }
            
            // Count expected videos
            try {
                $totalExpected = DB::table('before_genration as bg')
                    ->leftJoin('templates_by_user as tu', function($join) {
                        $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                             ->where('tu.content_type', '=', 'video');
                    })
                    ->where('bg.taskid', $task->id)
                    ->where('bg.content_type', 'video')
                    ->count('tu.id');
            } catch (\Exception $e) {
                \Log::error("Error counting expected videos for task {$id}: " . $e->getMessage());
                $totalExpected = 0;
            }
                
            // Count generated videos
            try {
                $generated = GeneratedVideo::where('taskid', $task->id)->count();
            } catch (\Exception $e) {
                \Log::error("Error counting generated videos for task {$id}: " . $e->getMessage());
                $generated = 0;
            }
            
            // Calculate progress percentage
            $percentage = $totalExpected > 0 ? round(($generated / $totalExpected) * 100) : 0;
            
            return response()->json([
                'success' => true,
                'status' => $task->status,
                'remark' => $task->remark,
                'total' => $totalExpected,
                'generated' => $generated,
                'percentage' => $percentage,
                'finished_at' => $task->finished_at ? \Carbon\Carbon::parse($task->finished_at)->format('d M Y H:i') : null
            ]);
            
        } catch (\Exception $e) {
            \Log::error("Error in getTaskProgress for task {$id}: " . $e->getMessage() . "\n" . $e->getTraceAsString());
            return response()->json([
                'success' => false, 
                'message' => 'Error retrieving task progress',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * Auto-start queue workers if none are running
     * This ensures workers are always available to process jobs
     */
    private function ensureWorkersRunning()
    {
        try {
            // Check if workers are already running
            if ($this->areWorkersRunning()) {
                \Log::info('[Auto-Workers] Workers already running, skipping start');
                return;
            }

            \Log::info('[Auto-Workers] No workers detected, starting workers...');

            $basePath = base_path();
            $pythonScript = $basePath . DIRECTORY_SEPARATOR . 'run_workers_persistent.py';

            // Check if script exists
            if (!file_exists($pythonScript)) {
                \Log::error('[Auto-Workers] Worker script not found: ' . $pythonScript);
                return;
            }

            // Start workers in background
            if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
                // Windows
                $command = 'start /B python "' . $pythonScript . '" > NUL 2>&1';
                pclose(popen($command, 'r'));
            } else {
                // Linux/Mac
                $command = 'python3 "' . $pythonScript . '" > /dev/null 2>&1 &';
                exec($command);
            }

            \Log::info('[Auto-Workers] Workers started successfully');

        } catch (\Exception $e) {
            \Log::error('[Auto-Workers] Failed to start workers: ' . $e->getMessage());
        }
    }

    /**
     * Check if queue workers are currently running
     */
    private function areWorkersRunning()
    {
        try {
            if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
                // Windows: Check specifically for the python supervisor script
                // 'wmic process where "CommandLine like \'%run_workers_persistent.py%\'" get ProcessId'
                $command = 'wmic process where "CommandLine like \'%run_workers_persistent.py%\'" get ProcessId 2>&1';
                exec($command, $output);
                
                // Filter out empty lines and error messages
                $runningProcesses = array_filter($output, function($line) {
                    return is_numeric(trim($line));
                });
                
                return count($runningProcesses) > 0;
            } else {
                // Linux/Mac: Check for artisan queue:work processes
                exec('ps aux | grep -c "queue:work"', $output);
                $workerCount = isset($output[0]) ? (int)$output[0] : 0;
                // Check if greater than 1 because grep itself counts as 1
                return $workerCount > 1; 
            }
        } catch (\Exception $e) {
            \Log::error('[Auto-Workers] Error checking worker status: ' . $e->getMessage());
            return true; // Assume running on error to prevent fork bomb
        }
    }


}
