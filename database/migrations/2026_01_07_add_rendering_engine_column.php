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
        Schema::table('before_genration', function (Blueprint $table) {
            $table->string('rendering_engine', 20)
                  ->default('moviepy')
                  ->after('animation_effect')
                  ->comment('Rendering engine: moviepy or ffmpeg');
        });
        
        Schema::table('tempstore', function (Blueprint $table) {
            $table->string('rendering_engine', 20)
                  ->default('moviepy')
                  ->after('animation_effect')
                  ->comment('Rendering engine: moviepy or ffmpeg');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('before_genration', function (Blueprint $table) {
            $table->dropColumn('rendering_engine');
        });
        
        Schema::table('tempstore', function (Blueprint $table) {
            $table->dropColumn('rendering_engine');
        });
    }
};
