<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;
use App\Models\TemplatesByUser;

class VideoTemplate extends Model
{
    use HasFactory;

    protected $table = 'video_templates';
    
    protected $fillable = [
        'name',
        'video_type',
        'image_path',
        'path',
        'video_file',
        'thumbnail',
        'duration',
        'width',
        'height',
        'is_active'
    ];

    public function templateByUsers()
    {
        return $this->hasMany(TemplatesByUser::class, 'master_template_id')
            ->where('content_type', 'video');
    }

    public function videosByUser()
    {
        return $this->hasMany(VideosByUser::class, 'video_template_id');
    }

    public function generatedVideos()
    {
        return $this->hasMany(GeneratedVideo::class, 'video_template_id');
    }

    /**
     * Scope to include user count from templates_by_user table
     * Similar to Template model's withUserCount scope
     */
    public function scopeWithUserCount($query)
    {
        return $query->leftJoin('templates_by_user', function($join) {
                $join->on('video_templates.id', '=', 'templates_by_user.master_template_id')
                     ->where('templates_by_user.content_type', '=', 'video');
            })
            ->select(
                'video_templates.id',
                'video_templates.name',
                'video_templates.video_type',
                'video_templates.image_path',
                'video_templates.path',
                'video_templates.is_active',
                'video_templates.created_at',
                DB::raw('COUNT(templates_by_user.id) as user_count')
            )
            ->groupBy(
                'video_templates.id',
                'video_templates.name',
                'video_templates.video_type',
                'video_templates.image_path',
                'video_templates.path',
                'video_templates.is_active',
                'video_templates.created_at'
            );
    }
}
