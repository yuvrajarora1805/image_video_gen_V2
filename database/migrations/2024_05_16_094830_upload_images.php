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
        Schema::create('upload_images', function (Blueprint $table) {
            $table->id();
            $table->integer('master_template_id');
            $table->string('path', 10);
            $table->string('uploadedimage', 255);
            $table->string('mimetype', 255);
            $table->text('created_by')->nullable();
            $table->timestamps();
           
        });
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('upload_images');
    }
};
