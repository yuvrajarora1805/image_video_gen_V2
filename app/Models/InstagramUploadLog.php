<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class InstagramUploadLog extends Model
{
    use HasFactory;

    const STATUS_PENDING = 'pending';
    const STATUS_PROCESSING = 'processing';
    const STATUS_PUBLISHED = 'published';
    const STATUS_FAILED = 'failed';

    protected $fillable = [
        'user_id',
        'platform',
        'credential_id',
        'video_path',
        'video_url',
        'caption',
        'media_container_id',
        'instagram_post_id',
        'status',
        'error_message',
    ];

    protected $casts = [
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    /**
     * Get the user that owns the upload log.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the credential used for this upload.
     */
    public function credential()
    {
        return $this->belongsTo(InstagramCredential::class, 'credential_id');
    }

    /**
     * Scope a query to only include pending uploads.
     */
    public function scopePending($query)
    {
        return $query->where('status', self::STATUS_PENDING);
    }

    /**
     * Scope a query to only include processing uploads.
     */
    public function scopeProcessing($query)
    {
        return $query->where('status', self::STATUS_PROCESSING);
    }

    /**
     * Scope a query to only include published uploads.
     */
    public function scopePublished($query)
    {
        return $query->where('status', self::STATUS_PUBLISHED);
    }

    /**
     * Scope a query to only include failed uploads.
     */
    public function scopeFailed($query)
    {
        return $query->where('status', self::STATUS_FAILED);
    }

    /**
     * Scope a query to only include uploads for a specific user.
     */
    public function scopeForUser($query, $userId)
    {
        return $query->where('user_id', $userId);
    }

    /**
     * Get the status badge color.
     */
    public function getStatusColorAttribute()
    {
        return match($this->status) {
            self::STATUS_PENDING => 'warning',
            self::STATUS_PROCESSING => 'info',
            self::STATUS_PUBLISHED => 'success',
            self::STATUS_FAILED => 'danger',
            default => 'secondary',
        };
    }

    /**
     * Get the Instagram post URL if published.
     */
    public function getInstagramUrlAttribute()
    {
        if ($this->instagram_post_id) {
            return "https://www.instagram.com/p/{$this->instagram_post_id}/";
        }
        return null;
    }
}
