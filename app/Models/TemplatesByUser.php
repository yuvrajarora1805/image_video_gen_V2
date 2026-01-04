<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TemplatesByUser extends Model
{
    use HasFactory;

    protected $table ="templates_by_user";

    protected $fillable = [
        'name',
        'path',
        'image',
        'memtype',
        'content_type',
    ];

    public function customer()
    {
        return $this->belongsTo(Customer::class, 'customer_id');
    }

    public function template()
    {
        return $this->belongsTo(Template::class, 'master_template_id');
    }

    public function videoTemplate()
    {
        return $this->belongsTo(VideoTemplate::class, 'master_template_id');
    }
}
