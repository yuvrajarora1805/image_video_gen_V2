<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Errorlogs extends Model
{
    use HasFactory;

    protected $table ="errorlogs";

    protected $fillable = [
        'task_id', 'message','failed_at'
    ];
}
