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
        // Add missing columns to existing tempgeneration table
        Schema::table('tempgeneration', function (Blueprint $table) {
            if (!Schema::hasColumn('tempgeneration', 'content_type')) {
                $table->enum('content_type', ['image', 'video'])->default('image')->after('backgroundpath');
            }
            if (!Schema::hasColumn('tempgeneration', 'video_type')) {
                $table->enum('video_type', ['portrait', 'landscape'])->nullable()->after('content_type');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('tempgeneration', function (Blueprint $table) {
            $table->dropColumn(['content_type', 'video_type']);
        });
    }
};
