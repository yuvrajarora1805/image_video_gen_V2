<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Crypt;

class InstagramCredential extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'customer_id',
        'credential_name',
        'access_token',
        'ig_user_id',
        'facebook_page_id',
        'is_active',
        'last_used_at',
        'expires_at',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'last_used_at' => 'datetime',
        'expires_at' => 'datetime',
    ];

    /**
     * Get the user that owns the credential.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the customer that owns the credential.
     */
    public function customer()
    {
        return $this->belongsTo(Customer::class);
    }

    /**
     * Get the upload logs for this credential.
     */
    public function uploadLogs()
    {
        return $this->hasMany(InstagramUploadLog::class, 'credential_id');
    }

    /**
     * Encrypt the access token when setting.
     */
    public function setAccessTokenAttribute($value)
    {
        $this->attributes['access_token'] = Crypt::encryptString($value);
    }

    /**
     * Decrypt the access token when getting.
     */
    public function getAccessTokenAttribute($value)
    {
        try {
            return Crypt::decryptString($value);
        } catch (\Exception $e) {
            return $value; // Return as-is if decryption fails
        }
    }

    /**
     * Scope a query to only include active credentials.
     */
    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    /**
     * Scope a query to only include credentials for a specific user.
     */
    public function scopeForUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Mark this credential as used.
     */
    public function markAsUsed()
    {
        $this->last_used_at = now();
        $this->save();
    }

    /**
     * Check if the credential is expired.
     */
    public function isExpired()
    {
        if (!$this->expires_at) {
            return false;
        }
        return $this->expires_at->isPast();
    }
}
