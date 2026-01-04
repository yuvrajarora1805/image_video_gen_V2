<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

DB::table('users')
    ->where('email', 'uvacreation@gmail.com')
    ->update(['password' => bcrypt('password')]);

echo "Password updated successfully!\n";
