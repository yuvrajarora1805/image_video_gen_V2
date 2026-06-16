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
        Schema::table('generated_image', function (Blueprint $table) {
            $table->index('taskid');
        });

        Schema::table('before_genration', function (Blueprint $table) {
            $table->index('taskid');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('generated_image', function (Blueprint $table) {
            $table->dropIndex(['taskid']);
        });

        Schema::table('before_genration', function (Blueprint $table) {
            $table->dropIndex(['taskid']);
        });
    }
};
