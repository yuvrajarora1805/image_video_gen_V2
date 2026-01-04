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
        // Add video-related columns to before_genration table if they don't exist
        Schema::table('before_genration', function (Blueprint $table) {
            if (!Schema::hasColumn('before_genration', 'backgroundvideo')) {
                $table->string('backgroundvideo')->nullable()->after('backgroundimage');
            }
            if (!Schema::hasColumn('before_genration', 'backgroundvideopath')) {
                $table->text('backgroundvideopath')->nullable()->after('backgroundvideo');
            }
            if (!Schema::hasColumn('before_genration', 'content_type')) {
                $table->enum('content_type', ['image', 'video'])->default('image')->after('backgroundvideopath');
            }
            if (!Schema::hasColumn('before_genration', 'video_type')) {
                $table->enum('video_type', ['portrait', 'landscape'])->nullable()->after('content_type');
            }
            if (!Schema::hasColumn('before_genration', 'type')) {
                $table->string('type')->nullable()->after('video_type');
            }
        });

        // Create generated_videos table if it doesn't exist
        if (!Schema::hasTable('generated_videos')) {
            Schema::create('generated_videos', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('taskid');
                $table->unsignedBigInteger('beforeid');
                $table->unsignedBigInteger('customerid');
                $table->unsignedBigInteger('video_template_id')->nullable();
                $table->unsignedBigInteger('user_template_id')->nullable();
                $table->string('video_path');
                $table->string('thumbnail_path')->nullable();
                $table->enum('video_type', ['portrait', 'landscape'])->default('landscape');
                $table->decimal('duration', 10, 2)->nullable();
                $table->bigInteger('size')->nullable();
                $table->tinyInteger('sent')->default(0);
                $table->timestamp('sent_date')->nullable();
                $table->timestamps();

                // Indexes
                $table->index('taskid');
                $table->index('beforeid');
                $table->index('customerid');
                $table->index('sent');
            });
        }

        // Add type column to task table if it doesn't exist
        Schema::table('task', function (Blueprint $table) {
            if (!Schema::hasColumn('task', 'type')) {
                $table->enum('type', ['image', 'video'])->default('image')->after('taskname');
            }
            if (!Schema::hasColumn('task', 'task_type')) {
                $table->enum('task_type', ['image', 'video'])->default('image')->after('type');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Remove columns from before_genration
        Schema::table('before_genration', function (Blueprint $table) {
            $table->dropColumn(['backgroundvideo', 'backgroundvideopath', 'content_type', 'video_type', 'type']);
        });

        // Drop generated_videos table
        Schema::dropIfExists('generated_videos');

        // Remove columns from task table
        Schema::table('task', function (Blueprint $table) {
            $table->dropColumn(['type', 'task_type']);
        });
    }
};
