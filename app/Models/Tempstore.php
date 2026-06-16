<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Tempstore extends Model
{
    use HasFactory;
    
    protected $table = "tempgeneration";
    
    protected $fillable = [
        'mastertemplateid',
        'backgroundimage',
        'backgroundpath',
        'backgroundvideo',
        'backgroundvideopath',
        'content_type',
        'video_type',
        'animation_effect',
        'rendering_engine',
    ];
}
