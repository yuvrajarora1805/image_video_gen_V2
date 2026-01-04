<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
   

    public function up()
{
    Schema::table('generated_image', function (Blueprint $table) {
        if (!Schema::hasColumn('generated_image', 'user_template_id')) {
            $table->integer('user_template_id')->after('master_template_id');
        }
    });
}

    /**
     * Reverse the migrations.
     */
    public function down()
    {
        Schema::table('generated_image', function (Blueprint $table) {
            $table->dropColumn('user_template_id'); // Drop the new column
        });
    }
};
