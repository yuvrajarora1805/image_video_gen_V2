<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // Force HTTPS only when accessed via ngrok (detects X-Forwarded-Proto header)
        if (request()->header('X-Forwarded-Proto') === 'https') {
            URL::forceScheme('https');
        }
        
        // Force root URL to include /public/ for XAMPP configuration
        // This ensures all route() and asset() calls include the correct base path
        if (config('app.url')) {
            URL::forceRootUrl(config('app.url'));
        }
    }
}
