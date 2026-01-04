<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\Auth\LoginController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\Auth\ResetPasswordController;
use App\Http\Controllers\Auth\ForgotPasswordController;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\ImageGenerationController;
use App\Http\Controllers\VideoGenerationController;
use App\Http\Controllers\TempFormController;
use App\Http\Controllers\TemplateByCustomerController;
use App\Http\Controllers\TemplateController;
use App\Http\Controllers\VideoTemplateController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return redirect('/dashboard
    ');
})->middleware('auth');

Route::get('/optimize', function() {
    $output = new Symfony\Component\Console\Output\BufferedOutput;
    Artisan::call('config:cache', $output);
    Artisan::call('route:cache', $output);
    return 'Optimization complete: ' . $output->fetch();
});


Route::get('/tables', function () {
    return view('tables');
})->name('tables')->middleware('auth');

Route::get('/wallet', function () {
    return view('wallet');
})->name('wallet')->middleware('auth');

Route::get('/RTL', function () {
    return view('RTL');
})->name('RTL')->middleware('auth');

Route::get('/profile', function () {
    return view('account-pages.profile');
})->name('profile')->middleware('auth');

Route::get('/signin', function () {
    return view('account-pages.signin');
})->name('signin');

Route::get('/signup', function () {
    return view('account-pages.signup');
})->name('signup')->middleware('guest');


// Route::get('/', function () {
//     return view('dashboard');
// })->name('')->middleware('auth');


Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard')->middleware('auth');

Route::get('/createuser', [CustomerController::class, 'create_user'])->name('createuser')->middleware('auth');
Route::post('/createuser', [CustomerController::class, 'create_user']);
Route::get('/users-management', [CustomerController::class, 'index'])->name('users-management')->middleware('auth');

Route::delete('/delete-user/{id}', [CustomerController::class, 'destroy']);

// Route::get('/template', function () {
//     return view('master-template.index');
// })->name('template')->middleware('auth');

// Route::get('/add-template', [TemplateController::class, 'create_template'])->name('add-template')->middleware('auth');
// Route::post('/add-template', [TemplateController::class, 'create_template']);


// Master Template
Route::get('/template' ,[TemplateController::class ,'index'])->name('template')->middleware('auth');
Route::get('/create-template', [TemplateController::class, 'showCreateForm'])->name('create-template-form');
Route::post('/create-template', [TemplateController::class, 'store'])->name('create-template');
Route::delete('/delete-template/{id}', [TemplateController::class, 'destroy'])->middleware('auth');

// Video Master Template
Route::get('/video-template', [VideoTemplateController::class, 'index'])->name('video-template')->middleware('auth');
Route::get('/create-video-template-master', [VideoTemplateController::class, 'showCreateForm'])->name('create-video-template-form')->middleware('auth');
Route::post('/create-video-template-master', [VideoTemplateController::class, 'store'])->name('create-video-template')->middleware('auth');
Route::delete('/delete-video-template-master/{id}', [VideoTemplateController::class, 'destroy'])->middleware('auth');
Route::get('/get-video-template-master-image/{id}', [VideoTemplateController::class, 'getTemplateImage'])->middleware('auth');

// asssign template to use and upload user template
Route::get('/assign' ,[TemplateByCustomerController::class ,'index'])->name('assign')->middleware('auth');
Route::get('/assign-template', [TemplateByCustomerController::class, 'showCreateForm'])->name('assign-template-form');
Route::post('/assign-template', [TemplateByCustomerController::class, 'store'])->name('assign-template');

Route::delete('/delete-item/{id}', [TemplateByCustomerController::class, 'destroy']);


// task module
Route::get('/get-template-image/{id}', [TemplateController::class, 'getTemplateImage']);

// temp data

Route::post('/tempdata', [TempFormController::class, 'storeTempData'])->name('tempdata');
Route::post('/tempdata/delete', [TempFormController::class, 'deleteTempData'])->name('tempdata.delete');
// Route::get('/get-template-image/{id}', [TempFormController::class, 'getTemplateImage']);

// before generation test 

Route::post('/process-temp-data', [ImageGenerationController::class, 'processTempData'])->name('process-temp-data');

Route::post('/execute-task/{id}', [ImageGenerationController::class, 'executeTask'])->name('executeTask');
Route::post('/delete-task/{id}', [ImageGenerationController::class, 'deleteTask'])->name('deleteTask');
Route::get('/check-task-status', [ImageGenerationController::class, 'checkTaskStatus']);

Route::post('/send-task/{id}', [ImageGenerationController::class, 'sendTask'])->name('sendTask');



Route::get('/get-task-details/{id}', [ImageGenerationController::class, 'getTaskDetails'])->name('getTaskDetails');
// Route::get('/getUserDetails/{taskId}/{masterTemplateId}', [ImageGenerationController::class, 'getUserDetails'])->name('getUserDetails');

Route::get('/getUserDetails/{masterTemplateId}', [ImageGenerationController::class, 'getUserDetails'])->name('getUserDetails');





// Route::post('/before-generate', [ImageGenerationController::class, 'beforegenerate'])->name('before-generate');
Route::post('/tempgenerate', [ImageGenerationController::class, 'tempstore'])->name('tempgenerate');

Route::get('/generate-template', [ImageGenerationController::class, 'showGenerateForm'])->name('template-generate-form');
Route::post('/generate-template', [ImageGenerationController::class, 'generateImage'])->name('template.generate');

Route::get('/generateimages', [ImageGenerationController::class, 'showGenerate'])->name('generateimages-form');

Route::get('/get-images', [ImageGenerationController::class, 'getImages']);

Route::get('/delete-old-images', [ImageGenerationController::class, 'deleteOldImages']);




Route::get('/sign-up', [RegisterController::class, 'create'])
    ->middleware('guest')
    ->name('sign-up');

Route::post('/sign-up', [RegisterController::class, 'store'])
    ->middleware('guest');

Route::get('/sign-in', [LoginController::class, 'create'])
    ->middleware('guest')
    ->name('sign-in');

Route::post('/sign-in', [LoginController::class, 'store'])
    ->middleware('guest');

Route::post('/logout', [LoginController::class, 'destroy'])
    ->middleware('auth')
    ->name('logout');

Route::get('/forgot-password', [ForgotPasswordController::class, 'create'])
    ->middleware('guest')
    ->name('password.request');

Route::post('/forgot-password', [ForgotPasswordController::class, 'store'])
    ->middleware('guest')
    ->name('password.email');

Route::get('/reset-password/{token}', [ResetPasswordController::class, 'create'])
    ->middleware('guest')
    ->name('password.reset');

Route::post('/reset-password', [ResetPasswordController::class, 'store'])
    ->middleware('guest');

// Video Generation Routes
Route::get('/video-templates', [VideoGenerationController::class, 'showVideoTemplates'])->name('video-template-form')->middleware('auth');
Route::get('/create-video-template', [VideoGenerationController::class, 'showCreateVideoTemplateForm'])->name('create-video-template-form')->middleware('auth');
Route::post('/create-video-template', [VideoGenerationController::class, 'uploadVideoTemplate'])->name('upload-video-template')->middleware('auth');
Route::delete('/delete-video-template/{id}', [VideoGenerationController::class, 'deleteVideoTemplate'])->name('delete-video-template')->middleware('auth');
Route::get('/generate-video-form', [VideoGenerationController::class, 'showGenerateForm'])->name('generate-video-form')->middleware('auth');
Route::post('/process-video-temp-data', [VideoGenerationController::class, 'processVideoTempData'])->name('process-video-temp-data')->middleware('auth');
Route::get('/getVideoUserDetails/{id}', [VideoGenerationController::class, 'getUserDetails'])->middleware('auth');
Route::get('/get-video-template-image/{id}', [VideoGenerationController::class, 'getVideoTemplateImage'])->middleware('auth');
Route::get('/generate-videos', [VideoGenerationController::class, 'showGenerateVideos'])->name('generate-videos')->middleware('auth');
Route::post('/execute-video-task/{id}', [VideoGenerationController::class, 'executeVideoTask'])->name('execute-video-task')->middleware('auth');
Route::get('/get-generated-videos/{taskId}', [VideoGenerationController::class, 'getGeneratedVideos'])->middleware('auth');
Route::get('/api/video-task-progress/{id}', [VideoGenerationController::class, 'getTaskProgress'])->middleware('auth'); // Progress Bar API
Route::get('/download-video/{id}', [VideoGenerationController::class, 'downloadVideo'])->name('download-video')->middleware('auth');

// GPU Acceleration API Routes
Route::post('/api/toggle-gpu', [VideoGenerationController::class, 'toggleGpu'])->middleware('auth');
Route::get('/api/gpu-status', [VideoGenerationController::class, 'getGpuStatus'])->middleware('auth');
Route::get('/download-task-videos/{taskId}', [VideoGenerationController::class, 'downloadTaskVideos'])->name('download-task-videos')->middleware('auth');

// Instagram Integration Routes
Route::prefix('instagram')->middleware('auth')->group(function () {
    Route::get('/credentials', [App\Http\Controllers\InstagramController::class, 'index'])->name('instagram.credentials');
    Route::post('/credentials', [App\Http\Controllers\InstagramController::class, 'store'])->name('instagram.credentials.store');
    Route::get('/credentials/{id}', [App\Http\Controllers\InstagramController::class, 'show'])->name('instagram.credentials.show');
    Route::put('/credentials/{id}', [App\Http\Controllers\InstagramController::class, 'update'])->name('instagram.credentials.update');
    Route::delete('/credentials/{id}', [App\Http\Controllers\InstagramController::class, 'destroy'])->name('instagram.credentials.destroy');
    Route::post('/credentials/{id}/test', [App\Http\Controllers\InstagramController::class, 'testCredential'])->name('instagram.credentials.test');
    
    Route::get('/upload-history', [App\Http\Controllers\InstagramController::class, 'uploadHistory'])->name('instagram.upload-history');
    Route::post('/upload', [App\Http\Controllers\InstagramController::class, 'uploadVideo'])->name('instagram.upload');
    Route::get('/upload-status/{id}', [App\Http\Controllers\InstagramController::class, 'checkUploadStatus'])->name('instagram.upload-status');
    Route::get('/active-credentials', [App\Http\Controllers\InstagramController::class, 'getActiveCredentials'])->name('instagram.active-credentials');
    
    // Customer video sending
    Route::get('/send-customer-videos', [App\Http\Controllers\InstagramController::class, 'showSendCustomerVideos'])->name('instagram.send-customer-videos');
    Route::get('/customer-credentials/{customerId}', [App\Http\Controllers\InstagramController::class, 'getCustomerCredentials'])->name('instagram.customer-credentials');
    Route::get('/customer-video-tasks/{customerId}', [App\Http\Controllers\InstagramController::class, 'getCustomerVideoTasks'])->name('instagram.customer-video-tasks');
    
    // Token Generator
    Route::get('/token-generator', [App\Http\Controllers\InstagramController::class, 'showTokenGenerator'])->name('instagram.token-generator');
    Route::post('/generate-token', [App\Http\Controllers\InstagramController::class, 'generateLongLivedToken'])->name('instagram.generate-token');
    
    // Page Token Fetcher
    Route::get('/page-token-fetcher', [App\Http\Controllers\InstagramController::class, 'showPageTokenFetcher'])->name('instagram.page-token-fetcher');
    Route::post('/fetch-page-tokens', [App\Http\Controllers\InstagramController::class, 'fetchPageTokens'])->name('instagram.fetch-page-tokens');
    
    // Master Uploader
    Route::get('/master-uploader', [App\Http\Controllers\InstagramController::class, 'showMasterUploader'])->name('instagram.master-uploader');
    Route::get('/all-pending-videos', [App\Http\Controllers\InstagramController::class, 'getAllPendingVideos'])->name('instagram.all-pending-videos');
    Route::post('/save-default-platform', [App\Http\Controllers\InstagramController::class, 'saveDefaultPlatform'])->name('instagram.save-default-platform');
    Route::get('/get-default-platform', [App\Http\Controllers\InstagramController::class, 'getDefaultPlatform'])->name('instagram.get-default-platform');
});

// Upload callback route (outside auth middleware for Python script access)
Route::post('/api/instagram/upload-callback', [App\Http\Controllers\InstagramController::class, 'uploadCallback'])->name('instagram.upload-callback');

// Debug route (remove after testing)
Route::get('/debug/customers', [App\Http\Controllers\DebugController::class, 'testCustomers'])->middleware('auth');
Route::get('/debug/customer-data/{customerId}', [App\Http\Controllers\InstagramController::class, 'debugCustomerData'])->middleware('auth');
Route::get('/debug/task-data/{taskId}', [App\Http\Controllers\InstagramController::class, 'debugTaskData'])->middleware('auth');



// if (Route::currentRouteName() == 'your_route_name') {
//     // Your code here
// }



Route::get('/laravel-examples/user-profile', [ProfileController::class, 'index'])->name('users.profile')->middleware('auth');
Route::put('/laravel-examples/user-profile/update', [ProfileController::class, 'update'])->name('users.update')->middleware('auth');
// Route::get('/laravel-examples/users-management', [UserController::class, 'index'])->name('users-management')->middleware('auth');
// Route::get('/users-management', [UserController::class, 'index'])->name('users-management')->middleware('auth');

// Temporary route to reset task 20 - REMOVE AFTER USE
Route::get('/reset-task-20-temp', function () {
    try {
        // Use the Task model which has the correct configuration
        $task = \App\Models\Task::find(20);
        
        if (!$task) {
            return response()->json([
                'success' => false,
                'error' => 'Task not found'
            ], 404);
        }
        
        $task->status = 0;
        $task->remark = 'Pending Execution';
        $task->finished_at = null;
        $task->save();
        
        return response()->json([
            'success' => true,
            'message' => 'Task reset successfully! Please refresh the page.',
            'current_status' => [
                'id' => $task->id,
                'taskname' => $task->taskname,
                'status' => $task->status,
                'remark' => $task->remark,
                'finished_at' => $task->finished_at
            ]
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'error' => $e->getMessage()
        ], 500);
    }
});
