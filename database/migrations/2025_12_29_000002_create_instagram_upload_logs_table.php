<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('instagram_upload_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('credential_id')->constrained('instagram_credentials')->onDelete('cascade');
            $table->string('video_path');
            $table->text('video_url'); // Public URL for Instagram
            $table->text('caption')->nullable();
            $table->string('media_container_id')->nullable();
            $table->string('instagram_post_id')->nullable();
            $table->enum('status', ['pending', 'processing', 'published', 'failed'])->default('pending');
            $table->text('error_message')->nullable();
            $table->timestamps();
            
            // Indexes for faster queries
            $table->index(['user_id', 'status']);
            $table->index('created_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('instagram_upload_logs');
    }
};
