<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Task;
use Illuminate\Support\Facades\DB;

class GenerateRecoverySql extends Command
{
    protected $signature = 'recover:sql {task_name}';
    protected $description = 'Generate raw MySQL INSERT statements for a failed video task';

    public function handle()
    {
        $taskName = $this->argument('task_name');
        $task = Task::where('taskname', $taskName)->first();

        if (!$task) {
            $this->error("Task not found.");
            return;
        }

        $taskId = $task->id;
        $logFile = storage_path("logs/gpu_task_{$taskId}.log");
        if (!file_exists($logFile)) {
            $this->error("Log file not found: {$logFile}");
            return;
        }

        $jsonDir = storage_path('app/gpu_tasks');
        $files = glob($jsonDir . "/task_{$taskId}_*.json");
        if (empty($files)) {
            $this->error("Metadata JSON file not found.");
            return;
        }

        rsort($files);
        $metadataFile = $files[0];

        $logContent = file_get_contents($logFile);
        $metadata = json_decode(file_get_contents($metadataFile), true);

        $metaMap = [];
        foreach ($metadata as $item) {
            $metaMap[basename($item['output'])] = $item['meta'];
        }

        $sqlFile = public_path("recovery_task_{$taskId}.sql");
        $sqlContent = "-- SQL Recovery for Task {$taskId}\n";
        $sqlContent .= "-- Run this in phpMyAdmin or your MySQL client\n\n";

        $savedCount = 0;
        if (preg_match('/RESULTS_JSON_START\s+(.*?)\s+RESULTS_JSON_END/s', $logContent, $jsonMatches)) {
            $jsonResults = json_decode($jsonMatches[1], true);
            if (is_array($jsonResults)) {
                foreach ($jsonResults as $res) {
                    if (!empty($res['success']) && !empty($res['output'])) {
                        $filename = basename($res['output']);
                        if (isset($metaMap[$filename])) {
                            $meta = $metaMap[$filename];
                            
                            $existing = DB::table('generated_videos')->where('generated_video', $meta['video_name'])->first();
                            if (!$existing) {
                                $now = date('Y-m-d H:i:s');
                                $customer_id = (int)$meta['customer_id'];
                                $master_id = (int)$meta['master_video_id'];
                                $user_video_id = (int)$meta['user_video_id'];
                                $task_id = (int)$meta['taskid'];
                                $beforeid = (int)$meta['beforeid'];
                                $video_name = addslashes($meta['video_name']);
                                $path = str_replace('\\', '/', addslashes($meta['output_path']));
                                $thumb = addslashes($meta['thumbnail_name']);
                                $type = addslashes($meta['video_type']);
                                $duration = (float)($res['time'] ?? 0);
                                $size = (float)($res['size'] ?? 0);
                                
                                $sqlContent .= "INSERT INTO generated_videos ";
                                $sqlContent .= "(customer_id, master_video_id, user_video_id, taskid, beforeid, generated_video, generated_path, thumbnail, video_type, duration, file_size, sent, created_at, updated_at) ";
                                $sqlContent .= "VALUES ($customer_id, $master_id, $user_video_id, $task_id, $beforeid, '$video_name', '$path', '$thumb', '$type', $duration, $size, 0, '$now', '$now');\n";
                                $savedCount++;
                            }
                        }
                    }
                }
            }
        }

        $sqlContent .= "\n-- Update task status\n";
        $sqlContent .= "UPDATE task SET status = 1, remark = 'Task Executed Successfully ({$savedCount} videos recovered)' WHERE id = {$taskId};\n";

        file_put_contents($sqlFile, $sqlContent);
        $this->info("Successfully generated SQL file: {$sqlFile}");
        $this->info("It contains {$savedCount} INSERT statements.");
        $this->info("You can open public/recovery_task_{$taskId}.sql to copy the SQL code.");
    }
}
