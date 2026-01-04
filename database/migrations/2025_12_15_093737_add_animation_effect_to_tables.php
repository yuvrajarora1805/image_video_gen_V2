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
        // Add animation_effect column to tempgeneration table (correct table name)
        if (Schema::hasTable('tempgeneration') && !Schema::hasColumn('tempgeneration', 'animation_effect')) {
            Schema::table('tempgeneration', function (Blueprint $table) {
                $table->string('animation_effect', 50)->default('wipe-in')->nullable();
            });
        }

        // Add animation_effect column to before_genration table
        if (Schema::hasTable('before_genration') && !Schema::hasColumn('before_genration', 'animation_effect')) {
            Schema::table('before_genration', function (Blueprint $table) {
                $table->string('animation_effect', 50)->default('wipe-in')->nullable();
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (Schema::hasColumn('tempgeneration', 'animation_effect')) {
            Schema::table('tempgeneration', function (Blueprint $table) {
                $table->dropColumn('animation_effect');
            });
        }

        if (Schema::hasColumn('before_genration', 'animation_effect')) {
            Schema::table('before_genration', function (Blueprint $table) {
                $table->dropColumn('animation_effect');
            });
        }
    }
};
