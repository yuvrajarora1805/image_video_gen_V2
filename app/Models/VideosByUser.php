<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VideosByUser extends Model
{
    use HasFactory;

    protected $table = 'videos_by_user';
    
    protected $fillable = [
        'customerid',
        'video_template_id',
        'video_path',
        'thumbnail_path',
        'duration',
        'size'
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customerid');
    }

    public function videoTemplate()
    {
        return $this->belongsTo(VideoTemplate::class, 'video_template_id');
    }
}
