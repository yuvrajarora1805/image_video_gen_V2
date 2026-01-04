<?php

namespace App\Services;

class VideoProcessor
{
    /**
     * Overlay customer video on background video using FFmpeg
     */
    public function overlayVideos($backgroundPath, $overlayPath, $outputPath, $videoType = 'portrait')
    {
        // Set dimensions based on video type
        $dimensions = $videoType === 'portrait' 
            ? ['width' => 1080, 'height' => 1920]  // 9:16 for Reels
            : ['width' => 1920, 'height' => 1080]; // 16:9 for Landscape

        // FFmpeg command to overlay videos with resizing
        $command = sprintf(
            'ffmpeg -i %s -i %s -filter_complex "[0:v]scale=%d:%d,setsar=1[bg];[1:v]scale=%d:%d,setsar=1[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2,format=yuv420p" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k -y %s 2>&1',
            escapeshellarg($backgroundPath),
            escapeshellarg($overlayPath),
            $dimensions['width'],
            $dimensions['height'],
            $dimensions['width'],
            $dimensions['height'],
            escapeshellarg($outputPath)
        );

        exec($command, $output, $returnCode);

        return $returnCode === 0;
    }

    /**
     * Get video information using FFprobe
     */
    public function getVideoInfo($videoPath)
    {
        $command = sprintf(
            'ffprobe -v quiet -print_format json -show_format -show_streams %s',
            escapeshellarg($videoPath)
        );

        exec($command, $output, $returnCode);

        if ($returnCode !== 0) {
            return null;
        }

        $json = json_decode(implode('', $output), true);
        
        $videoStream = null;
        foreach ($json['streams'] ?? [] as $stream) {
            if ($stream['codec_type'] === 'video') {
                $videoStream = $stream;
                break;
            }
        }

        if (!$videoStream) {
            return null;
        }

        return [
            'duration' => (int)($json['format']['duration'] ?? 0),
            'width' => (int)($videoStream['width'] ?? 0),
            'height' => (int)($videoStream['height'] ?? 0),
            'size' => (int)($json['format']['size'] ?? 0),
        ];
    }

    /**
     * Generate thumbnail from video
     */
    public function generateThumbnail($videoPath, $thumbnailPath, $timeInSeconds = 1)
    {
        $command = sprintf(
            'ffmpeg -i %s -ss %d -vframes 1 -y %s 2>&1',
            escapeshellarg($videoPath),
            $timeInSeconds,
            escapeshellarg($thumbnailPath)
        );

        exec($command, $output, $returnCode);

        return $returnCode === 0 && file_exists($thumbnailPath);
    }

    /**
     * Check if FFmpeg is installed
     */
    public function isFFmpegInstalled()
    {
        exec('ffmpeg -version 2>&1', $output, $returnCode);
        return $returnCode === 0;
    }
}
