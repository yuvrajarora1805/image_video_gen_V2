<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customer extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'email',
        'mobile',
        'whatsappgroup',
        'created_by',
        'updated_by'
    ];

    /**
     * Get the Instagram credentials for this customer.
     */
    public function instagramCredentials()
    {
        return $this->hasMany(\App\Models\InstagramCredential::class);
    }
}
