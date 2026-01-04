<?php

namespace App\Http\Controllers;

use App\Models\InstagramCredential;
use App\Models\InstagramUploadLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Process;
use Illuminate\Support\Facades\Validator;

class InstagramController extends Controller
{
    /**
     * Display the credentials management page.
     */
    public function index()
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credentials = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by'); // Include customers with NULL created_by
                    });
            })
            ->with(['customer'])
            ->orderBy('created_at', 'desc')
            ->get();

        // Get customers: owned by user OR created_by is NULL (legacy customers)
        $customers = \App\Models\Customer::where(function($query) use ($userId, $userName) {
                $query->where('created_by', $userId)
                    ->orWhere('created_by', $userName)
                    ->orWhereNull('created_by'); // Include all customers with NULL created_by
            })
            ->orderBy('name')
            ->get();

        return view('instagram.credentials', compact('credentials', 'customers'));
    }

    /**
     * Store a new Instagram credential.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'customer_id' => 'nullable|exists:customers,id',
            'credential_name' => 'required|string|max:255',
            'access_token' => 'required|string',
            'ig_user_id' => 'required|string|max:255',
            'facebook_page_id' => 'nullable|string|max:255',
            'expires_at' => 'nullable|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $credential = InstagramCredential::create([
            'user_id' => $request->customer_id ? null : Auth::id(),
            'customer_id' => $request->customer_id,
            'credential_name' => $request->credential_name,
            'access_token' => $request->access_token,
            'ig_user_id' => $request->ig_user_id,
            'facebook_page_id' => $request->facebook_page_id,
            'expires_at' => $request->expires_at,
            'is_active' => true,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Credential added successfully!',
            'credential' => $credential->load('customer')
        ]);
    }

    /**
     * Get a single credential.
     */
    public function show($id)
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credential = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by');
                    });
            })
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'credential' => $credential
        ]);
    }

    /**
     * Update an existing credential.
     */
    public function update(Request $request, $id)
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credential = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by');
                    });
            })
            ->findOrFail($id);

        $validator = Validator::make($request->all(), [
            'credential_name' => 'required|string|max:255',
            'access_token' => 'required|string',
            'ig_user_id' => 'required|string|max:255',
            'facebook_page_id' => 'nullable|string|max:255',
            'expires_at' => 'nullable|date',
            'is_active' => 'boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'errors' => $validator->errors()
            ], 422);
        }

        $credential->update($request->only([
            'credential_name',
            'access_token',
            'ig_user_id',
            'facebook_page_id',
            'expires_at',
            'is_active'
        ]));

        return response()->json([
            'success' => true,
            'message' => 'Credential updated successfully!',
            'credential' => $credential
        ]);
    }

    /**
     * Delete a credential.
     */
    public function destroy($id)
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credential = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by');
                    });
            })
            ->findOrFail($id);

        $credential->delete();

        return response()->json([
            'success' => true,
            'message' => 'Credential deleted successfully!'
        ]);
    }

    /**
     * Test if a credential is valid.
     */
    public function testCredential($id)
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credential = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by');
                    });
            })
            ->findOrFail($id);

        $results = [
            'instagram' => null,
            'facebook' => null
        ];

        // Test Instagram
        try {
            $url = "https://graph.facebook.com/v19.0/{$credential->ig_user_id}";
            $response = file_get_contents($url . "?fields=id,username&access_token=" . $credential->access_token);
            
            if ($response === false) {
                throw new \Exception("Failed to connect to Instagram API");
            }

            $data = json_decode($response, true);
            
            if (isset($data['error'])) {
                throw new \Exception($data['error']['message'] ?? 'Invalid credentials');
            }

            $results['instagram'] = [
                'success' => true,
                'message' => 'Instagram credentials valid!',
                'username' => $data['username'] ?? 'Unknown'
            ];

        } catch (\Exception $e) {
            $results['instagram'] = [
                'success' => false,
                'message' => 'Instagram test failed: ' . $e->getMessage()
            ];
        }

        // Test Facebook if Page ID is configured
        if ($credential->facebook_page_id) {
            try {
                $url = "https://graph.facebook.com/v19.0/{$credential->facebook_page_id}";
                $response = file_get_contents($url . "?fields=id,name&access_token=" . $credential->access_token);
                
                if ($response === false) {
                    throw new \Exception("Failed to connect to Facebook API");
                }

                $data = json_decode($response, true);
                
                if (isset($data['error'])) {
                    throw new \Exception($data['error']['message'] ?? 'Invalid Facebook credentials');
                }

                $results['facebook'] = [
                    'success' => true,
                    'message' => 'Facebook credentials valid!',
                    'page_name' => $data['name'] ?? 'Unknown'
                ];

            } catch (\Exception $e) {
                $results['facebook'] = [
                    'success' => false,
                    'message' => 'Facebook test failed: ' . $e->getMessage()
                ];
            }
        }

        // Determine overall success
        $overallSuccess = $results['instagram']['success'] ?? false;
        if ($credential->facebook_page_id) {
            $overallSuccess = $overallSuccess && ($results['facebook']['success'] ?? false);
        }

        return response()->json([
            'success' => $overallSuccess,
            'message' => $this->formatTestMessage($results, $credential->facebook_page_id),
            'results' => $results
        ]);
    }

    /**
     * Format test results message
     */
    private function formatTestMessage($results, $hasFacebookPageId)
    {
        $messages = [];
        
        if ($results['instagram']['success']) {
            $messages[] = "✅ Instagram: " . ($results['instagram']['username'] ?? 'Valid');
        } else {
            $messages[] = "❌ Instagram: Failed";
        }

        if ($hasFacebookPageId) {
            if ($results['facebook']['success']) {
                $messages[] = "✅ Facebook: " . ($results['facebook']['page_name'] ?? 'Valid');
            } else {
                $messages[] = "❌ Facebook: Failed";
            }
        }

        return implode("\n", $messages);
    }

    /**
     * Display upload history.
     */
    public function uploadHistory(Request $request)
    {
        $query = InstagramUploadLog::where('user_id', Auth::id())
            ->with('credential')
            ->orderBy('created_at', 'desc');

        // Filter by status if provided
        if ($request->has('status') && $request->status !== 'all') {
            $query->where('status', $request->status);
        }

        $uploads = $query->paginate(20);

        return view('instagram.upload-history', compact('uploads'));
    }

    /**
     * Upload a video to Instagram.
     */
    public function uploadVideo(Request $request)
    {
        // Log incoming request for debugging
        \Log::info('Upload video request received', $request->all());
        
        $validator = Validator::make($request->all(), [
            'credential_id' => 'required|exists:instagram_credentials,id',
            'video_path' => 'required|string',
            'video_url' => 'required|string',
            'caption' => 'nullable|string|max:2200',
            'platform' => 'required|in:instagram,facebook,both',
        ]);

        if ($validator->fails()) {
            \Log::error('Validation failed', $validator->errors()->toArray());
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors()
            ], 422);
        }

        // Verify credential belongs to user or their customers
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $credential = InstagramCredential::where(function($query) use ($userId, $userName) {
                $query->where('user_id', Auth::id())
                    ->orWhereHas('customer', function($q) use ($userId, $userName) {
                        $q->where('created_by', $userId)
                          ->orWhere('created_by', $userName)
                          ->orWhereNull('created_by');
                    });
            })
            ->where('id', $request->credential_id)
            ->where('is_active', true)
            ->firstOrFail();

        // Create upload log
        $uploadLog = InstagramUploadLog::create([
            'user_id' => Auth::id(),
            'credential_id' => $credential->id,
            'video_path' => $request->video_path,
            'video_url' => $request->video_url,
            'caption' => $request->caption ?? '',
            'status' => InstagramUploadLog::STATUS_PENDING,
            'platform' => $request->platform === 'both' ? 'instagram' : $request->platform,
        ]);

        try {
            $pythonPath = 'C:/Users/yuvra/AppData/Local/Programs/Python/Python313/python.exe';
            $callbackUrl = 'http://localhost/imgen/public_html/public_html/public/api/instagram/upload-callback';
            
            if ($request->platform === 'both') {
                if (!$credential->facebook_page_id) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Facebook Page ID not configured for this credential'
                    ], 400);
                }

                // Create FB log (IG log already created as $uploadLog)
                $facebookLog = InstagramUploadLog::create([
                    'user_id' => Auth::id(),
                    'credential_id' => $credential->id,
                    'video_path' => $request->video_path,
                    'video_url' => $request->video_url,
                    'caption' => $request->caption,
                    'status' => InstagramUploadLog::STATUS_PENDING,
                    'platform' => 'facebook'
                ]);

                // Run Python scripts for both platforms with named arguments
            $igScript = base_path('instagram_uploader.py');
            $fbScript = base_path('facebook_uploader.py');
            
            // Use unique log files to prevent overwriting/locking in parallel execution
            $logFileIg = storage_path("logs/debug_python_instagram_{$uploadLog->id}.log");
            $logFileFb = storage_path("logs/debug_python_facebook_{$facebookLog->id}.log");
            
            $cmdIg = "\"{$pythonPath}\" \"{$igScript}\" --access-token \"{$credential->access_token}\" --ig-user-id \"{$credential->ig_user_id}\" --video-url \"{$request->video_url}\" --caption \"{$request->caption}\" --log-id {$uploadLog->id} --callback-url \"{$callbackUrl}\"";
            $cmdFb = "\"{$pythonPath}\" \"{$fbScript}\" --access-token \"{$credential->access_token}\" --page-id \"{$credential->facebook_page_id}\" --video-url \"{$request->video_url}\" --caption \"{$request->caption}\" --log-id {$facebookLog->id} --callback-url \"{$callbackUrl}\"";
                
                $bgCmdIg = "start \"\" /B cmd /c \"{$cmdIg} > {$logFileIg} 2>&1\"";
                $bgCmdFb = "start \"\" /B cmd /c \"{$cmdFb} > {$logFileFb} 2>&1\"";
                
                // Log the Facebook command for debugging
                \Log::info('Facebook Upload Command', ['command' => $cmdFb]);
                
                pclose(popen($bgCmdIg, 'r'));
                pclose(popen($bgCmdFb, 'r'));

                return response()->json([
                    'success' => true,
                    'message' => 'Uploads started for Instagram and Facebook.',
                    'upload_log_id' => $uploadLog->id,
                    'facebook_log_id' => $facebookLog->id,
                    'status' => 'processing'
                ]);

            } else {
                // Single Platform (Instagram or Facebook)
                $script = ($request->platform === 'facebook') 
                    ? base_path('facebook_uploader.py')
                    : base_path('instagram_uploader.py');
                
                $pageIdOrUserId = ($request->platform === 'facebook')
                    ? $credential->facebook_page_id
                    : $credential->ig_user_id;
                
                $pageIdArgName = ($request->platform === 'facebook') ? '--page-id' : '--ig-user-id';
                
                $platformName = ($request->platform === 'facebook') ? 'facebook' : 'instagram';
                $logFile = storage_path("logs/debug_python_{$platformName}_{$uploadLog->id}.log");
                
                $command = "\"{$pythonPath}\" \"{$script}\" --access-token \"{$credential->access_token}\" {$pageIdArgName} \"{$pageIdOrUserId}\" --video-url \"{$request->video_url}\" --caption \"{$request->caption}\" --log-id {$uploadLog->id} --callback-url \"{$callbackUrl}\"";
                $bgCommand = "start \"\" /B cmd /c \"{$command} > {$logFile} 2>&1\"";
                
                // Log the command for debugging
                \Log::info('Single Platform Upload Command', [
                    'platform' => $request->platform,
                    'command' => $command
                ]);
                
                // Also write to file for full command visibility
                file_put_contents(storage_path('logs/last_facebook_command.txt'), $command);
                
                pclose(popen($bgCommand, 'r'));

                return response()->json([
                    'success' => true,
                    'message' => 'Upload started successfully.',
                    'upload_log_id' => $uploadLog->id,
                    'status' => 'processing'
                ]);
            }

        } catch (\Exception $e) {
            \Log::error('Upload exception occurred', [
                'message' => $e->getMessage(),
                'file' => $e->getFile(),
                'line' => $e->getLine(),
                'trace' => $e->getTraceAsString()
            ]);
            
            $uploadLog->update([
                'status' => InstagramUploadLog::STATUS_FAILED,
                'error_message' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Upload failed: ' . $e->getMessage(),
                'error_details' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Check upload status.
     */
    public function checkUploadStatus($id)
    {
        $uploadLog = InstagramUploadLog::where('user_id', Auth::id())
            ->with('credential')
            ->findOrFail($id);

        return response()->json([
            'success' => true,
            'upload' => $uploadLog
        ]);
    }

    /**
     * Get active credentials for dropdown.
     */
    public function getActiveCredentials()
    {
        $credentials = InstagramCredential::where('user_id', Auth::id())
            ->where('is_active', true)
            ->get(['id', 'credential_name', 'ig_user_id']);

        return response()->json([
            'success' => true,
            'credentials' => $credentials
        ]);
    }

    /**
     * Show send customer videos page.
     */
    public function showSendCustomerVideos()
    {
        $userId = (string) Auth::id();
        $userName = Auth::user()->name;

        $customers = \App\Models\Customer::where(function($query) use ($userId, $userName) {
                $query->where('created_by', $userId)
                    ->orWhere('created_by', $userName)
                    ->orWhereNull('created_by'); // Include customers with NULL created_by
            })
            ->with('instagramCredentials')
            ->orderBy('name')
            ->get();

        return view('instagram.send-customer-videos', compact('customers'));
    }

    /**
     * Get credentials for a specific customer.
     */
    public function getCustomerCredentials($customerId)
    {
        $credentials = InstagramCredential::where('customer_id', $customerId)
            ->where('is_active', true)
            ->get(['id', 'credential_name', 'ig_user_id']);

        return response()->json([
            'success' => true,
            'credentials' => $credentials
        ]);
    }

    /**
     * Get video tasks for a specific customer.
     * Queries generated_videos table and filters by customer_id
     */
    public function getCustomerVideoTasks($customerId)
    {
        try {
            // Get customer info
            $customer = \App\Models\Customer::find($customerId);
            
            if (!$customer) {
                return response()->json([
                    'success' => false,
                    'message' => 'Customer not found',
                    'tasks' => []
                ]);
            }

            // Get all video tasks that have videos for this customer
            // Filter by customer_id and only include generated videos (sent = 0)
            $videoTasks = \App\Models\Task::whereHas('generatedVideos', function($query) use ($customerId) {
                    $query->where('customer_id', $customerId)
                          ->where('sent', 0); // Only unsent videos
                })
                ->where('status', 1) // Only completed tasks
                ->with(['generatedVideos' => function($query) use ($customerId) {
                    $query->where('customer_id', $customerId)
                          ->where('sent', 0)
                          ->orderBy('id', 'desc');
                }])
                ->orderBy('id', 'desc')
                ->get();

            $tasks = [];
            
            foreach ($videoTasks as $task) {
                $videos = [];
                
                foreach ($task->generatedVideos as $video) {
                    // strict PHP filtering to ensure only this customer's videos are shown
                    if ($video->customer_id != $customerId) {
                        continue;
                    }

                    // Build video URL
                    $videoUrl = asset('videos/generated_video/' . $video->generated_video);
                    
                    $videos[] = [
                        'id' => $video->id,
                        'filename' => $video->generated_video,
                        'video_path' => public_path('videos/generated_video/' . $video->generated_video),
                        'video_url' => $videoUrl,
                        'thumbnail_url' => $video->thumbnail ? asset('videos/thumbnails/' . $video->thumbnail) : '',
                        'duration' => $video->duration,
                        'file_size' => $video->file_size ? round($video->file_size / 1024 / 1024, 2) . ' MB' : '',
                        'created_at' => $video->created_at->format('d M Y H:i')
                    ];
                }
                
                if (count($videos) > 0) {
                    $tasks[] = [
                        'id' => $task->id,
                        'taskname' => $task->taskname ?: "Task #{$task->id}",
                        'customer_name' => $customer->name,
                        'customer_email' => $customer->email,
                        'totalvideos' => count($videos),
                        'pending' => count($videos),
                        'created_at' => $task->created_at->format('d M Y H:i'),
                        'videos' => $videos
                    ];
                }
            }

            return response()->json([
                'success' => true,
                'tasks' => $tasks,
                'total_tasks' => count($tasks),
                'customer' => [
                    'id' => $customer->id,
                    'name' => $customer->name,
                    'email' => $customer->email
                ]
            ]);
        } catch (\Exception $e) {
            \Log::error('Error in getCustomerVideoTasks: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error loading tasks: ' . $e->getMessage(),
                'tasks' => []
            ], 500);
        }
    }

    /**
     * Debug endpoint to check database data
     */
    public function debugCustomerData($customerId)
    {
        $customer = \App\Models\Customer::find($customerId);
        
        $generatedImages = \DB::table('generated_image')
            ->where('customer_id', $customerId)
            ->get();

        $allImages = \DB::table('generated_image')
            ->join('customers', 'generated_image.customer_id', '=', 'customers.id')
            ->select('generated_image.id', 'generated_image.customer_id', 'customers.name', 'generated_image.user_template_id', 'generated_image.created_at')
            ->orderBy('generated_image.created_at', 'desc')
            ->limit(20)
            ->get();

        return response()->json([
            'customer' => $customer,
            'customer_id_searched' => $customerId,
            'images_for_this_customer' => $generatedImages,
            'total_count_for_customer' => $generatedImages->count(),
            'sample_all_images' => $allImages
        ]);
    }

    /**
     * Debug endpoint to check task data
     */
    public function debugTaskData($taskId)
    {
        $task = \DB::table('task')->where('id', $taskId)->first();
        
        // Try to find generated content by task name or ID
        $generatedByTaskId = \DB::table('generated_image')
            ->where('taskid', $taskId)
            ->get();

        $generatedByTaskName = \DB::table('generated_image')
            ->where('taskid', 'LIKE', '%' . $taskId . '%')
            ->get();

        return response()->json([
            'task' => $task,
            'task_id_searched' => $taskId,
            'generated_by_taskid' => $generatedByTaskId,
            'total_by_taskid' => $generatedByTaskId->count(),
            'generated_by_taskname' => $generatedByTaskName,
            'total_by_taskname' => $generatedByTaskName->count()
        ]);
    }

    /**
     * Callback endpoint for Python script to update upload status
     */
    public function uploadCallback(Request $request)
    {
        try {
            $logId = $request->input('log_id');
            $status = $request->input('status');
            $mediaContainerId = $request->input('media_container_id');
            $postId = $request->input('post_id');
            $errorMessage = $request->input('error_message');

            $uploadLog = InstagramUploadLog::find($logId);
            
            if (!$uploadLog) {
                return response()->json([
                    'success' => false,
                    'message' => 'Upload log not found'
                ], 404);
            }

            // Update upload log
            $uploadLog->update([
                'status' => $status,
                'media_container_id' => $mediaContainerId,
                'instagram_post_id' => $postId,
                'error_message' => $errorMessage
            ]);

            // Mark credential as used if published
            if ($status === 'published') {
                $credential = InstagramCredential::find($uploadLog->credential_id);
                if ($credential) {
                    $credential->markAsUsed();
                }
                
                // Mark the video as sent in generated_videos table
                try {
                    // Extract filename from video_path or video_url
                    $videoPath = $uploadLog->video_path;
                    $videoUrl = $uploadLog->video_url;
                    
                    // Try to find the video by matching the generated_video filename
                    if ($videoPath) {
                        $filename = basename($videoPath);
                        $video = \App\Models\GeneratedVideo::where('generated_video', $filename)->first();
                        
                        if ($video && $video->sent == 0) {
                            $video->update([
                                'sent' => 1,
                                'sent_date' => now()
                            ]);
                            \Log::info("Marked video as sent", ['video_id' => $video->id, 'filename' => $filename]);
                        }
                    }
                    
                    // Fallback: try matching by video URL
                    if (!isset($video) && $videoUrl) {
                        $urlFilename = basename(parse_url($videoUrl, PHP_URL_PATH));
                        $video = \App\Models\GeneratedVideo::where('generated_video', $urlFilename)->first();
                        
                        if ($video && $video->sent == 0) {
                            $video->update([
                                'sent' => 1,
                                'sent_date' => now()
                            ]);
                            \Log::info("Marked video as sent (via URL)", ['video_id' => $video->id, 'filename' => $urlFilename]);
                        }
                    }
                } catch (\Exception $e) {
                    \Log::error('Error marking video as sent: ' . $e->getMessage());
                }
            }

            \Log::info('Upload callback received', [
                'log_id' => $logId,
                'status' => $status,
                'post_id' => $postId
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Status updated successfully'
            ]);

        } catch (\Exception $e) {
            \Log::error('Upload callback error: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error updating status: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Show token generator page
     */
    public function showTokenGenerator()
    {
        return view('instagram.token-generator');
    }

    /**
     * Generate long-lived token from short-lived token
     */
    public function generateLongLivedToken(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'app_id' => 'required',
            'app_secret' => 'required',
            'short_token' => 'required'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'All fields are required',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $appId = $request->app_id;
            $appSecret = $request->app_secret;
            $shortToken = $request->short_token;

            // Step 1: Exchange for long-lived user token
            $exchangeUrl = "https://graph.facebook.com/v19.0/oauth/access_token?grant_type=fb_exchange_token&client_id={$appId}&client_secret={$appSecret}&fb_exchange_token={$shortToken}";
            
            $response = file_get_contents($exchangeUrl);
            $data = json_decode($response, true);

            if (!isset($data['access_token'])) {
                return response()->json([
                    'success' => false,
                    'message' => 'Failed to exchange token',
                    'error' => $data['error']['message'] ?? 'Unknown error'
                ], 400);
            }

            $longLivedToken = $data['access_token'];

            // Step 2: Get user pages (for page access token)
            $pagesUrl = "https://graph.facebook.com/v19.0/me/accounts?access_token={$longLivedToken}";
            $pagesResponse = file_get_contents($pagesUrl);
            $pagesData = json_decode($pagesResponse, true);

            $pages = [];
            if (isset($pagesData['data'])) {
                foreach ($pagesData['data'] as $page) {
                    // Get Instagram Business Account ID for this page
                    $igAccountUrl = "https://graph.facebook.com/v19.0/{$page['id']}?fields=instagram_business_account&access_token={$page['access_token']}";
                    $igResponse = @file_get_contents($igAccountUrl);
                    $igData = json_decode($igResponse, true);

                    $pages[] = [
                        'page_id' => $page['id'],
                        'page_name' => $page['name'],
                        'page_token' => $page['access_token'],
                        'ig_user_id' => $igData['instagram_business_account']['id'] ?? null
                    ];
                }
            }

            return response()->json([
                'success' => true,
                'long_lived_token' => $longLivedToken,
                'expires_in' => $data['expires_in'] ?? 5184000, // 60 days
                'pages' => $pages
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error generating token: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Show page token fetcher page
     */
    public function showPageTokenFetcher()
    {
        return view('instagram.page-token-fetcher');
    }

    /**
     * Fetch Facebook page access tokens from user access token
     */
    public function fetchPageTokens(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'access_token' => 'required|string'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Access token is required',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $userAccessToken = $request->access_token;

            // Fetch user's Facebook pages
            $pagesUrl = "https://graph.facebook.com/v19.0/me/accounts?access_token={$userAccessToken}";
            $response = @file_get_contents($pagesUrl);
            
            if ($response === false) {
                throw new \Exception('Failed to connect to Facebook API. Please check your access token.');
            }

            $data = json_decode($response, true);

            if (isset($data['error'])) {
                throw new \Exception($data['error']['message'] ?? 'Invalid access token');
            }

            $pages = [];
            if (isset($data['data']) && is_array($data['data'])) {
                foreach ($data['data'] as $page) {
                    $pages[] = [
                        'id' => $page['id'],
                        'name' => $page['name'],
                        'access_token' => $page['access_token'],
                        'category' => $page['category'] ?? 'Unknown',
                        'tasks' => $page['tasks'] ?? []
                    ];
                }
            }

            return response()->json([
                'success' => true,
                'pages' => $pages,
                'total' => count($pages)
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Show master uploader page
     */
    public function showMasterUploader()
    {
        return view('instagram.master-uploader');
    }

    /**
     * Get all pending videos across all customers
     */
    public function getAllPendingVideos()
    {
        try {
            $userId = (string) Auth::id();
            $userName = Auth::user()->name;

            // Get all customers for this user
            $customers = \App\Models\Customer::where(function($query) use ($userId, $userName) {
                    $query->where('created_by', $userId)
                        ->orWhere('created_by', $userName)
                        ->orWhereNull('created_by');
                })
                ->with(['instagramCredentials' => function($query) {
                    $query->where('is_active', true);
                }])
                ->orderBy('name')
                ->get();

            $customersWithVideos = [];

            foreach ($customers as $customer) {
                // Get pending videos for this customer
                $pendingVideos = \App\Models\GeneratedVideo::where('customer_id', $customer->id)
                    ->where('sent', 0)
                    ->get();

                if ($pendingVideos->count() > 0) {
                    $videos = [];
                    foreach ($pendingVideos as $video) {
                        $videoPath = public_path('videos/generated_video/' . $video->generated_video);
                        
                        // Only include videos that actually exist on disk
                        if (file_exists($videoPath)) {
                            $videos[] = [
                                'id' => $video->id,
                                'filename' => $video->generated_video,
                                'video_path' => $videoPath,
                                'video_url' => asset('videos/generated_video/' . $video->generated_video),
                            ];
                        } else {
                            \Log::warning("Video file not found", [
                                'video_id' => $video->id,
                                'customer_id' => $customer->id,
                                'filename' => $video->generated_video
                            ]);
                        }
                    }

                    // Only add customer if they have actual video files
                    if (count($videos) > 0) {

                    $credentials = [];
                    foreach ($customer->instagramCredentials as $cred) {
                        $credentials[] = [
                            'id' => $cred->id,
                            'credential_name' => $cred->credential_name,
                            'ig_user_id' => $cred->ig_user_id,
                        ];
                    }

                        $customersWithVideos[] = [
                            'id' => $customer->id,
                            'name' => $customer->name,
                            'email' => $customer->email,
                            'pending_count' => count($videos), // Actual file count
                            'videos' => $videos,
                            'credentials' => $credentials
                        ];
                    }
                }
            }

            return response()->json([
                'success' => true,
                'customers' => $customersWithVideos,
                'total_customers' => count($customersWithVideos),
                'total_videos' => array_sum(array_column($customersWithVideos, 'pending_count'))
            ]);

        } catch (\Exception $e) {
            \Log::error('Error in getAllPendingVideos: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Error loading pending videos: ' . $e->getMessage(),
                'customers' => []
            ], 500);
        }
    }

    /**
     * Save user's default upload platform preference
     */
    public function saveDefaultPlatform(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'platform' => 'required|in:instagram,facebook,both'
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid platform value',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $user = Auth::user();
            $user->default_upload_platform = $request->platform;
            $user->save();

            return response()->json([
                'success' => true,
                'message' => 'Default platform saved successfully',
                'platform' => $request->platform
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error saving preference: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get user's default upload platform preference
     */
    public function getDefaultPlatform()
    {
        try {
            $user = Auth::user();
            $platform = $user->default_upload_platform ?? 'instagram';

            return response()->json([
                'success' => true,
                'platform' => $platform
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error loading preference: ' . $e->getMessage(),
                'platform' => 'instagram'
            ], 500);
        }
    }
}
