<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\InstagramUploadLog;
use App\Models\InstagramCredential;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class UploadVideoCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'app:upload-video {log_id : The ID of the upload log}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Upload video to Instagram or Facebook based on the log entry';

    /**
     * Graph API Version
     */
    protected $apiVersion = 'v25.0';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $logId = $this->argument('log_id');
        $this->info("Starting upload for Log ID: {$logId}");

        $log = InstagramUploadLog::with('credential')->find($logId);

        if (!$log) {
            $this->error("Log ID {$logId} not found.");
            return 1;
        }

        if (!$log->credential) {
            $this->updateStatus($log, InstagramUploadLog::STATUS_FAILED, null, null, 'Credential not found');
            return 1;
        }

        try {
            // Determine platform
            // If platform column exists, use it. Otherwise guess based on log structure?
            // User schema update added 'platform'. Use it.
            $platform = $log->platform ?? 'instagram'; // Default for older logs

            $this->info("Platform: {$platform}");

            if ($platform === 'facebook') {
                $this->uploadToFacebook($log);
            } else {
                $this->uploadToInstagram($log);
            }

        } catch (\Exception $e) {
            $this->error("Error: " . $e->getMessage());
            $this->updateStatus($log, InstagramUploadLog::STATUS_FAILED, null, null, $e->getMessage());
            return 1;
        }

        return 0;
    }

    /**
     * Upload to Facebook
     */
    protected function uploadToFacebook($log)
    {
        $pageId = $log->credential->facebook_page_id;
        $accessToken = $log->credential->access_token;

        if (!$pageId) {
            throw new \Exception("Facebook Page ID not configured for this credential.");
        }

        $url = "https://graph.facebook.com/{$this->apiVersion}/{$pageId}/videos";
        
        $this->info("Uploading to Facebook Page {$pageId}...");

        $response = Http::post($url, [
            'access_token' => $accessToken,
            'file_url' => $log->video_url,
            'description' => $log->caption,
            'is_reel' => 'true' // Upload as Reel
        ]);

        if ($response->failed()) {
            throw new \Exception("Facebook Upload Failed: " . $response->body());
        }

        $data = $response->json();
        $videoId = $data['id'] ?? null;

        if (!$videoId) {
            throw new \Exception("No Video ID returned from Facebook.");
        }

        $this->info("Facebook Upload Success! Video ID: {$videoId}");
        $this->updateStatus($log, InstagramUploadLog::STATUS_PUBLISHED, null, $videoId);
    }

    /**
     * Upload to Instagram
     */
    protected function uploadToInstagram($log)
    {
        $igUserId = $log->credential->ig_user_id;
        $accessToken = $log->credential->access_token;

        // 1. Create Media Container
        $this->info("Creating Instagram Media Container...");
        $url = "https://graph.facebook.com/{$this->apiVersion}/{$igUserId}/media";

        $response = Http::post($url, [
            'access_token' => $accessToken,
            'video_url' => $log->video_url,
            'caption' => $log->caption,
            'media_type' => 'REELS'
        ]);

        if ($response->failed()) {
            throw new \Exception("Container Creation Failed: " . $response->body());
        }

        $containerId = $response->json()['id'] ?? null;
        if (!$containerId) {
            throw new \Exception("No Container ID returned.");
        }

        $this->info("Container Created: {$containerId}");
        // Update DB immediately
        $this->updateStatus($log, InstagramUploadLog::STATUS_PROCESSING, $containerId);

        // 2. Wait for Processing
        $this->waitForProcessing($containerId, $accessToken);

        // 3. Publish
        $this->info("Publishing Reel...");
        $publishUrl = "https://graph.facebook.com/{$this->apiVersion}/{$igUserId}/media_publish";
        
        $pubResponse = Http::post($publishUrl, [
            'access_token' => $accessToken,
            'creation_id' => $containerId
        ]);

        if ($pubResponse->failed()) {
            throw new \Exception("Publishing Failed: " . $pubResponse->body());
        }

        $postId = $pubResponse->json()['id'] ?? null;
        if (!$postId) {
            throw new \Exception("No Post ID returned.");
        }

        $this->info("Published! Post ID: {$postId}");
        $this->updateStatus($log, InstagramUploadLog::STATUS_PUBLISHED, $containerId, $postId);
        
        // Mark credential as used
        $log->credential->markAsUsed();
    }

    /**
     * Poll status until finished
     */
    protected function waitForProcessing($containerId, $accessToken)
    {
        $url = "https://graph.facebook.com/{$this->apiVersion}/{$containerId}";
        $attempts = 0;
        $maxAttempts = 30; // 30 * 10s = 5 mins max

        while ($attempts < $maxAttempts) {
            $this->info("Checking status... (Attempt " . ($attempts + 1) . ")");
            
            $response = Http::get($url, [
                'access_token' => $accessToken,
                'fields' => 'status_code,status'
            ]);

            if ($response->failed()) {
                 throw new \Exception("Status Check Failed: " . $response->body());
            }

            $status = $response->json()['status_code'] ?? '';
            $this->info("Current Status: {$status}");

            if ($status === 'FINISHED') {
                return true;
            }

            if ($status === 'ERROR') {
                throw new \Exception("Instagram processing failed with status ERROR.");
            }

            sleep(10);
            $attempts++;
        }

        throw new \Exception("Processing timeout.");
    }

    /**
     * Update Log in Database
     */
    protected function updateStatus($log, $status, $containerId = null, $postId = null, $error = null)
    {
        $updateData = ['status' => $status];
        
        if ($containerId) $updateData['media_container_id'] = $containerId;
        if ($postId) $updateData['instagram_post_id'] = $postId;
        if ($error) $updateData['error_message'] = $error;

        $log->update($updateData);
        
        $this->info("Database updated -> Status: {$status}");
    }
}
