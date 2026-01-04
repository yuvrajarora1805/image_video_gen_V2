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
        Schema::create('templates_by_user', function (Blueprint $table) {
            $table->id();
            $table->integer('master_template_id');
            $table->integer('customer_id');
            $table->string('customer_template', 255);
            $table->string('template_path', 10);
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
        Schema::dropIfExists('templates_by_user');
    }
};
