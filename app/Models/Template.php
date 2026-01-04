<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\DB;

use App\Models\TemplatesByUser;

class Template extends Model
{
    use HasFactory;
    protected $table = "templates";
    
    public function templateByUsers()
    {
        return $this->hasMany(TemplatesByUser::class, 'master_template_id');
    }



    public function scopeWithUserCount($query)
    {
        return $query->leftJoin('templates_by_user', 'templates.id', '=', 'templates_by_user.master_template_id')
            ->select('templates.image','templates.id', 'templates.name', 'templates.created_at', DB::raw('COUNT(templates_by_user.id) as user_count'))
            ->groupBy('templates.image','templates.id', 'templates.name', 'templates.created_at');
    }
}
