<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class GeneratedVideo extends Model
{
    use HasFactory;

    protected $table = 'generated_videos';
    
    protected $fillable = [
        'taskid',
        'beforeid',
        'customer_id',
        'master_video_id',
        'user_video_id',
        'generated_video',
        'generated_path',
        'thumbnail',
        'video_type',
        'duration',
        'file_size',
        'sent',
        'sent_date'
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id');
    }

    public function task()
    {
        return $this->belongsTo(Task::class, 'taskid');
    }

    public function videoTemplate()
    {
        return $this->belongsTo(VideoTemplate::class, 'video_template_id');
    }

    public function userVideo()
    {
        return $this->belongsTo(VideosByUser::class, 'user_template_id');
    }
}
