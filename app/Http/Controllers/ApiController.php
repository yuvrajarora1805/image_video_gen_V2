<?php

namespace App\Http\Controllers;

use App\Models\BeforeGenerate;
use App\Models\ImageGeneration;
use App\Models\GeneratedVideo;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ApiController extends Controller
{

    public function gettasklist()
    {
        try {
            $tasklist = Task::where('sent_status', 0)->get();

            if ($tasklist->isEmpty()) {
                return response()->json([]);
            }

            $taskIds = $tasklist->pluck('id')->toArray();

            // Bulk fetch expected images count from before_genration and templates_by_user
            $expectedCounts = DB::table('before_genration as bg')
                ->leftJoin('templates_by_user as tu', 'bg.mastertemplateid', '=', 'tu.master_template_id')
                ->select('bg.taskid', DB::raw('count(tu.id) as expected_count'))
                ->whereIn('bg.taskid', $taskIds)
                ->groupBy('bg.taskid')
                ->get()
                ->pluck('expected_count', 'taskid');

            // Bulk fetch actual generated images stats from generated_image
            $imageStats = ImageGeneration::select('taskid',
                DB::raw('count(*) as total'),
                DB::raw('sum(case when sent = 1 then 1 else 0 end) as sent'),
                DB::raw('sum(case when sent = 0 then 1 else 0 end) as pending')
            )
            ->whereIn('taskid', $taskIds)
            ->groupBy('taskid')
            ->get()
            ->keyBy('taskid');

            $sno = 0;
            $data = [];

            foreach ($tasklist as $task) {
                $sno++;

                $expectedImages = $expectedCounts->get($task->id, 0);
                $stats = $imageStats->get($task->id);

                $totalimage = $stats ? (int)$stats->total : 0;
                $totalsentimage = $stats ? (int)$stats->sent : 0;
                $totalfailedimage = $stats ? (int)$stats->pending : 0;

                // If no images generated yet, show expected as pending
                $finalTotal = max($expectedImages, $totalimage);
                $finalPending = $totalimage > 0 ? $totalfailedimage : $expectedImages;

                $data[] = [
                    'id' => $task->id,
                    'taskname' => $task->taskname,
                    'totalimage' => $finalTotal,
                    'send' => $totalsentimage,
                    'pending' => $finalPending,
                    'sno' => $sno,
                ];
            }

            return response()->json($data);
        }
        catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function getVideoTaskList()
    {
        try {
            $tasklist = Task::where('task_type', 'video')->get();

            $sno = 0;
            $data = [];

            foreach ($tasklist as $task) {
                $sno++;

                // Count expected videos from templates
                $expectedVideos = \DB::table('before_genration as bg')
                    ->leftJoin('templates_by_user as tu', function ($join) {
                    $join->on('bg.mastertemplateid', '=', 'tu.master_template_id')
                        ->where('tu.content_type', '=', 'video');
                })
                    ->where('bg.taskid', $task->id)
                    ->where('bg.content_type', 'video')
                    ->count('tu.id');

                // Count actual generated videos
                $totalvideos = GeneratedVideo::where('taskid', $task->id)->count();
                $totalsentvideos = GeneratedVideo::where('taskid', $task->id)->where('sent', 1)->count();
                $totalfailedvideos = GeneratedVideo::where('taskid', $task->id)->where('sent', 0)->count();

                // If no videos generated yet, show expected as pending
                $finalTotal = max($expectedVideos, $totalvideos);
                $finalPending = $totalvideos > 0 ? $totalfailedvideos : $expectedVideos;

                $data[] = [
                    'id' => $task->id,
                    'taskname' => $task->taskname,
                    'totalvideos' => $finalTotal,
                    'send' => $totalsentvideos,
                    'pending' => $finalPending,
                    'status' => $task->status,
                    'sent_status' => $task->sent_status,
                    'sno' => $sno,
                ];
            }

            // Always return an array (even if only one or zero tasks)
            return response()->json($data);
        }
        catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    public function updateVideoStatus(Request $request)
    {
        try {
            $currentDateTime = now();
            $videoId = $request->videoId;

            $video = GeneratedVideo::find($videoId);

            if ($video) {
                $updateData = [
                    'sent' => 1,
                    'sent_date' => $currentDateTime,
                ];
                if ($video->update($updateData)) {
                    // Check if all videos for this task are now sent
                    $taskId = $video->taskid;
                    $remainingVideos = GeneratedVideo::where('taskid', $taskId)
                        ->where('sent', 0)
                        ->count();

                    // If no more pending videos, update task status
                    if ($remainingVideos == 0) {
                        Task::where('id', $taskId)->update([
                            'sent_status' => 1,
                            'remark' => 'Success - All Videos Sent'
                        ]);
                    }

                    return response()->json(['message' => 'Video sent successfully'], 200);
                }
                else {
                    return response()->json(['error' => 'Failed to update video'], 500);
                }
            }
            else {
                return response()->json(['error' => 'Video not found'], 404);
            }

        }
        catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }


    public function getsubtasklist(Request $request)
    {
        try {
            $subtasklist = BeforeGenerate::where('status', 0)
                ->where('taskid', $request->taskid)
                ->get();
            if ($subtasklist->isEmpty()) {
                return response()->json([]);
            }

            return response()->json($subtasklist);
        }
        catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }


    public function getimagelist(Request $request)
    {

        try {
            $imagelist = ImageGeneration::where('sent', 0)
                ->where('beforeid', $request->subtaskid)
                ->get();

            if ($imagelist->isEmpty()) {
                return response()->json(null);
            }

            return response()->json($imagelist);
        }
        catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }


    public function getimage(Request $request)
    {


        try {
            $data = [];

            $image = ImageGeneration::select('customers.whatsappgroup', 'generated_image.genarted_image', 'generated_image.id')->join('customers', 'customers.id', '=', 'generated_image.customer_id')
                ->where('generated_image.id', $request->imageid)
                ->where('sent', 0)
                ->first();

            if ($image) {
                $url = public_path('img/generated_image/' . $image->genarted_image);
                if (file_exists($url)) {
                    $imageData = file_get_contents($url);
                    $base64Image = base64_encode($imageData);
                    $attachmentData = [
                        'data' => $base64Image,
                        'name' => $image->genarted_image,
                    ];
                    $data = [
                        'attachment' => $attachmentData,
                        'group' => $image->whatsappgroup,
                    ];
                }
            }


            return response([
                $data
            ]);
        }
        catch (\Exception $e) {

            $response = [
                'success' => false,
                'message' => 'Failed to retrieve images.',
                'error' => $e->getMessage(),
            ];

            return response()->json($response, 500);
        }
    }


    public function updatestatus(Request $request)
    {

        try {
            $currentDateTime = now();
            $imageId = $request->imageId;

            $image = ImageGeneration::find($imageId);

            if ($image) {
                $updateData = [
                    'sent' => 1,
                    'sent_date' => $currentDateTime,
                ];
                if ($image->update($updateData)) {
                    // Check if all images for this task are now sent
                    $taskId = $image->taskid;
                    $remainingImages = ImageGeneration::where('taskid', $taskId)
                        ->where('sent', 0)
                        ->count();

                    // If no more pending images, update task status
                    if ($remainingImages == 0) {
                        Task::where('id', $taskId)->update([
                            'sent_status' => 1,
                            'remark' => 'Success - All Images Sent'
                        ]);
                    }

                    // Update successful
                    return response()->json(['message' => 'Image sent successfully'], 200);
                }
                else {
                    // Update failed
                    return response()->json(['error' => 'Failed to update image'], 500);
                }
            }
            else {
                // Image not found
                return response()->json(['error' => 'Image not found'], 404);
            }

        }
        catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    public function getGeneratedVideosList(Request $request)
    {
        try {
            $taskId = $request->taskId;

            if (!$taskId) {
                return response()->json(['success' => false, 'message' => 'Task ID is required'], 400);
            }

            $videos = GeneratedVideo::where('taskid', $taskId)
                ->with(['customer'])
                ->orderBy('id', 'desc')
                ->get();

            if ($videos->isEmpty()) {
                return response()->json(['success' => true, 'videos' => [], 'message' => 'No videos generated yet']);
            }

            $videoList = [];
            foreach ($videos as $video) {
                $videoList[] = [
                    'id' => $video->id,
                    'customer_name' => $video->customer ? $video->customer->name : 'Unknown',
                    'customer_email' => $video->customer ? $video->customer->email : '',
                    'customer_mobile' => $video->customer ? $video->customer->mobile : '',
                    'video_name' => $video->generated_video,
                    'video_url' => asset('videos/generated_video/' . $video->generated_video),
                    'thumbnail_url' => $video->thumbnail ? asset('videos/thumbnails/' . $video->thumbnail) : '',
                    'video_type' => $video->video_type,
                    'duration' => $video->duration,
                    'file_size' => $video->file_size ? round($video->file_size / 1024 / 1024, 2) . ' MB' : '',
                    'sent' => $video->sent,
                    'created_at' => $video->created_at->format('d M Y H:i')
                ];
            }

            return response()->json(['success' => true, 'videos' => $videoList, 'total' => count($videoList)]);
        }
        catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => $e->getMessage()], 500);
        }
    }

    /**
     * Get GPU acceleration status
     */
    public function getGpuStatus()
    {
        try {
            // Run Python script to check GPU status
            $pythonScript = base_path('video_generator.py');
            $command = "python \"{$pythonScript}\" --check-gpu 2>&1";

            $output = shell_exec($command);

            if ($output) {
                // Clean up the output (remove any extra whitespace/newlines)
                $output = trim($output);

                $gpuStatus = json_decode($output, true);

                if ($gpuStatus && is_array($gpuStatus)) {
                    return response()->json([
                        'success' => true,
                        'enabled' => $gpuStatus['enabled'] ?? false,
                        'available' => $gpuStatus['available'] ?? false,
                        'encoder' => $gpuStatus['encoder'] ?? null,
                        'message' => $gpuStatus['message'] ?? 'Unknown status'
                    ]);
                }
            }

            // Fallback: check .env file
            $useGpu = env('USE_GPU', '1');
            return response()->json([
                'success' => true,
                'enabled' => $useGpu === '1',
                'available' => false,
                'encoder' => null,
                'message' => 'Unable to detect GPU, using .env configuration'
            ]);

        }
        catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Toggle GPU acceleration on/off
     */
    public function toggleGpu()
    {
        try {
            $envFile = base_path('.env');

            if (!file_exists($envFile)) {
                return response()->json([
                    'success' => false,
                    'message' => '.env file not found'
                ], 404);
            }

            $envContent = file_get_contents($envFile);

            // Read current value directly from file to avoid cache issues
            $currentValue = '1'; // default
            if (preg_match('/USE_GPU=(.*)/', $envContent, $matches)) {
                $currentValue = trim($matches[1]);
            }

            $newValue = ($currentValue === '1') ? '0' : '1';

            // Check if USE_GPU exists in .env
            if (strpos($envContent, 'USE_GPU=') !== false) {
                // Update existing value
                $envContent = preg_replace(
                    '/USE_GPU=.*/',
                    'USE_GPU=' . $newValue,
                    $envContent
                );
            }
            else {
                // Add new line
                $envContent .= "\nUSE_GPU=" . $newValue;
            }

            file_put_contents($envFile, $envContent);

            // Clear config cache
            \Artisan::call('config:clear');

            // Set environment variable for current request
            putenv("USE_GPU={$newValue}");
            $_ENV['USE_GPU'] = $newValue;

            // Get updated GPU status
            $pythonScript = base_path('video_generator.py');
            $command = "python \"{$pythonScript}\" --check-gpu 2>&1";
            $output = shell_exec($command);

            $gpuStatus = null;
            if ($output) {
                $output = trim($output);
                $gpuStatus = json_decode($output, true);
            }

            return response()->json([
                'success' => true,
                'enabled' => $newValue === '1',
                'available' => $gpuStatus['available'] ?? false,
                'encoder' => $gpuStatus['encoder'] ?? null,
                'message' => 'GPU acceleration ' . ($newValue === '1' ? 'enabled' : 'disabled')
            ]);

        }
        catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
