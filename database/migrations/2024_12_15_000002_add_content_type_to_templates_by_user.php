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
        // Add content_type column to templates_by_user table if it doesn't exist
        Schema::table('templates_by_user', function (Blueprint $table) {
            if (!Schema::hasColumn('templates_by_user', 'content_type')) {
                $table->enum('content_type', ['image', 'video'])->default('image')->after('memtype');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('templates_by_user', function (Blueprint $table) {
            if (Schema::hasColumn('templates_by_user', 'content_type')) {
                $table->dropColumn('content_type');
            }
        });
    }
};
