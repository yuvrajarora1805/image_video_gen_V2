<?php

use App\Http\Controllers\ApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
 Route::get('/task-list', [ApiController::class,'gettasklist'])->name('task-list');
  Route::get('/subtask-list', [ApiController::class,'getsubtasklist'])->name('subtask-list');
  Route::get('/image-list', [ApiController::class,'getimagelist'])->name('image-list');

  Route::get('/send-image', [ApiController::class,'getimage'])->name('send-image');
  Route::post('/update-image-status', [ApiController::class,'updatestatus'])->name('update-image-status');

  // Video API endpoints
  Route::get('/video-task-list', [ApiController::class,'getVideoTaskList'])->name('video-task-list');
  Route::get('/generated-videos-list', [ApiController::class,'getGeneratedVideosList'])->name('generated-videos-list');
  Route::post('/update-video-status', [ApiController::class,'updateVideoStatus'])->name('update-video-status');

  // GPU acceleration endpoints
  Route::get('/gpu-status', [ApiController::class,'getGpuStatus'])->name('gpu-status');
  Route::post('/toggle-gpu', [ApiController::class,'toggleGpu'])->name('toggle-gpu');