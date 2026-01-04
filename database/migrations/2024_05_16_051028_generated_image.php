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
        Schema::create('generated_image', function (Blueprint $table) {
            $table->id();
            $table->integer('customer_id');
            $table->integer('master_template_id');
            $table->integer('user_template_id');
            $table->string('genarted_path', 10);
            $table->string('genarted_image', 255);
            $table->string('memtype', 255);
            $table->text('created_by')->nullable();
            $table->timestamps();
           
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('generated_image');
    }
};
