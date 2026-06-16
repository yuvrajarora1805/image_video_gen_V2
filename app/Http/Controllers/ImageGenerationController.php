<?php

namespace App\Http\Controllers;

use App\Models\BeforeGenerate;
use App\Models\ImageGeneration;
use App\Models\Errorlogs;
use App\Models\Logs;
use App\Models\Task;
use App\Models\Template;
use App\Models\TemplatesByUser;
use App\Models\Tempstore;
use Illuminate\Http\Request;
use Intervention\Image\ImageManager;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Date;
use Carbon\Carbon;
// use Intervention\Image\Drivers\Imagick\Driver;
use Intervention\Image\Drivers\Gd\Driver;
use Illuminate\Support\Facades\File;

class ImageGenerationController extends Controller
{


    public function showGenerateForm()
    {
        $templates = Template::all();

        return view('generate_image.form', compact('templates'));
    }

    public function showGenerate()
    {
        $tasks = Task::select('task.*')
            ->where('task.task_type', 'image')
            ->where('task.is_active', 1)
            ->orderBy('task.id', 'desc')
            ->paginate(50);

        // Add counts to each task
        foreach ($tasks as $task) {
            // Count expected images (from before_genration and templates_by_user)
            $totalExpected = DB::table('before_genration as bg')
                ->leftJoin('templates_by_user as tu', 'bg.mastertemplateid', '=', 'tu.master_template_id')
                ->where('bg.taskid', $task->id)
                ->where('bg.content_type', 'image')
                ->count('tu.id');
            
            // Count generated images
            $generated = DB::table('generated_image')
                ->where('taskid', $task->id)
                ->selectRaw('COUNT(*) as total, SUM(CASE WHEN sent = 1 THEN 1 ELSE 0 END) as sent_count, SUM(CASE WHEN sent = 0 THEN 1 ELSE 0 END) as pending_count')
                ->first();
            
            $task->totalimage = max($totalExpected, $generated->total ?? 0);
            $task->send = $generated->sent_count ?? 0;
            $task->pending = $generated->pending_count ?? 0;
        }

        return view('generate_image.generate_image', compact('tasks'));
    }


    // public function processTempData(Request $request)
    // {

    //     $tempData = Tempstore::all();
    //     $taskCount = Task::count();
    //     $nextTaskNumber = $taskCount + 1;
    //     $task = new Task();
    //     $task->taskname = 'Task' . sprintf('%02d', $nextTaskNumber);
    //     $task->remark = 'Pending';
    //     $task->save();

    //     foreach ($tempData as $data) {


    //         $beforeGeneration = new BeforeGenerate();
    //         $beforeGeneration->mastertemplateid = $data->mastertemplateid;
    //         $beforeGeneration->backgroundimage = $data->backgroundimage;
    //         $beforeGeneration->backgroundpath = $data->backgroundpath;
    //         $beforeGeneration->taskid =  $task->id;
    //         $beforeGeneration->save();
    //     }


    //     Tempstore::truncate();


    //     return response()->json(['success' => true, 'task_name' => $task->taskname]);
    // }

    public function processTempData(Request $request)
    {
        DB::beginTransaction();

        try {
            $tempData = Tempstore::all();

            if ($tempData->isEmpty()) {
                throw new \Exception('No data found in Tempstore');
            }

            $taskCount = Task::count();
            $nextTaskNumber = $taskCount + 1;

            $task = new Task();
            $task->taskname = 'Task' . sprintf('%02d', $nextTaskNumber);
            $task->remark = 'Pending';
            $task->save();

            foreach ($tempData as $data) {
                $beforeGeneration = new BeforeGenerate();
                $beforeGeneration->mastertemplateid = $data->mastertemplateid;
                $beforeGeneration->backgroundimage = $data->backgroundimage;
                $beforeGeneration->backgroundpath = $data->backgroundpath;
                $beforeGeneration->taskid = $task->id;
                $beforeGeneration->status = 1;
                $beforeGeneration->save();
            }

           

            $logs = new Logs();
            $logs->task_id = $task->id;
            $logs->status = 'success';
            $logs->message = 'Task created successfully';
            $logs->save();


            DB::commit();

            Tempstore::truncate();

            return response()->json(['success' => true, 'task_name' => $task->taskname]);
        } catch (\Exception $e) {
            DB::rollBack();

            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Task Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();


            return response()->json(['success' => false, 'message' => 'No data found'], 400);
        }
    }

    public function executeTask($id)
    {
        // Increase execution time limit for large tasks (2600+ images)
        set_time_limit(7200); // 2 hours for large batches
        ini_set('memory_limit', '2048M'); // 2GB memory
        
        DB::beginTransaction();

        try {
            $task = Task::find($id);

            if ($task && $task->status == 0) {
                $task->status = 2;
                $task->save();

                $taskprocess = BeforeGenerate::where('taskid', $id)->where('status', 1)->get();

                if ($taskprocess->isNotEmpty()) {
                    foreach ($taskprocess as $td) {
                        $backgroundpath = public_path('img/background_image/' . $td->backgroundimage);

                        $frontimages = TemplatesByUser::where('master_template_id', $td->mastertemplateid)->where('content_type', 'image')->get();
                        // dd($frontimages);
                        foreach ($frontimages as $fi) {
                            try {
                                $frontpath = public_path('img/user_template/' . $fi->customer_template);

                                $background = $this->openImage($backgroundpath);
                                $front = $this->openImage($frontpath);

                            $backgroundWidth = imagesx($background);
                            $backgroundHeight = imagesy($background);

                            $resizedFront = imagecreatetruecolor($backgroundWidth, $backgroundHeight);

                            imagealphablending($resizedFront, false);
                            imagesavealpha($resizedFront, true);
                            $transparent = imagecolorallocatealpha($resizedFront, 0, 0, 0, 127);
                            imagefill($resizedFront, 0, 0, $transparent);

                            $frontWidth = imagesx($front);
                            $frontHeight = imagesy($front);

                            imagecopyresampled(
                                $resizedFront,
                                $front,
                                0,
                                0,
                                0,
                                0,
                                $backgroundWidth,
                                $backgroundHeight,
                                $frontWidth,
                                $frontHeight
                            );

                            imagecopy(
                                $background,
                                $resizedFront,
                                0,
                                0,
                                0,
                                0,
                                $backgroundWidth,
                                $backgroundHeight
                            );

                            $imgName = 'combined_image_' . time() . '_' . uniqid() . '.jpg';
                            $outputPath = public_path('img/generated_image/' . $imgName);

                            $newgenerate = new ImageGeneration();
                            $newgenerate->customer_id = $fi->customer_id;
                            $newgenerate->master_template_id = $td->mastertemplateid;
                            $newgenerate->user_template_id = $fi->id;
                            $newgenerate->taskid = $id;
                            $newgenerate->beforeid = $td->id;
                            $newgenerate->genarted_path = $outputPath;
                            $newgenerate->genarted_image =  $imgName;
                            $newgenerate->memtype = 'jpg';
                            $newgenerate->save();


                            imagejpeg($background, $outputPath, 100);
                            } catch (\Exception $e) {
                                // Log individual image error but continue processing others
                                \Log::warning("Failed to generate image for customer {$fi->customer_id}: " . $e->getMessage());
                                
                                $errorlog = new Errorlogs();
                                $errorlog->task_id = $id;
                                $errorlog->message = "Customer {$fi->customer_id}: " . $e->getMessage();
                                $errorlog->save();
                                
                                continue; // Skip this image and continue with next one
                            }
                        }

                        BeforeGenerate::where('id', $td->id)->update(['status' => false]);
                    }
                }

                // Removed unnecessary sleep(5)
                $ldate = date('Y-m-d H:i:s');

                // After processing:
                $task->status = 1;
                $task->remark = 'Generated - Ready to Send';
                $task->finished_at = $ldate;
                $task->save();

                DB::commit();

                $logs = new Logs();
                $logs->task_id = $task->id;
                $logs->status = 'success';
                $logs->message = 'Images generated successfully. Ready to send.';

                $logs->save();
                // Log successful task execution


                return response()->json(['success' => true, 'message' => 'Task executed successfully.']);
            } else {
                return response()->json(['success' => true, 'message' => 'Task executed already.']);
            }
        } catch (\Exception $e) {
            DB::rollBack();
            $error = new  Errorlogs();
            $error->task_id = $id;
            $error->message = $e->getMessage();

            $error->save();


            return response()->json(['success' => false, 'message' => 'Task execution failed.']);
        }
    }

    private function openImage($path)
    {
        if (!file_exists($path)) {
            \Log::error('Image file not found: ' . $path);
            throw new \Exception('Image file not found: ' . $path);
        }

        $info = getimagesize($path);
        if ($info === false) {
            throw new \Exception('Invalid image file: ' . $path);
        }
        
        $mime = $info['mime'];

        switch ($mime) {
            case 'image/jpeg':
                return imagecreatefromjpeg($path);
            case 'image/png':
                return imagecreatefrompng($path);
            case 'image/gif':
                return imagecreatefromgif($path);
            default:
                throw new \Exception('Unsupported image type: ' . $mime);
        }
    }


    public function checkTaskStatus(Request $request)
    {
        $task = Task::find($request->id);
        if ($task) {
            return response()->json(['status' => $task->task_status]);
        }
        return response()->json(['status' => Null]);
    }




    public function sendTask($id)
    {
        DB::beginTransaction();
        
        try {
            $data = [];
            $task = Task::find($id);

            if ($task && $task->status == 1) {
                $i = 0;

                $before = BeforeGenerate::where('taskid', $task->id)->where('status', 0)->get();

                foreach ($before as $bg) {
                    $genrate = ImageGeneration::select('generated_image.id', 'customers.whatsappgroup', 'generated_image.genarted_path', 'generated_image.genarted_image')
                        ->join('customers', 'generated_image.customer_id', 'customers.id')
                        ->where('beforeid', $bg->id)
                        ->where('sent', 0)
                        ->get();
                        
                    if ($genrate->count() > 0) {
                        foreach ($genrate as $item) {
                            $out['whatsappgroup'] = $item->whatsappgroup;
                            $out['genarted_image'] = $item->genarted_image;
                            $out['genarted_path'] = $item->genarted_path;
                            $data[] = $out;

                            // Mark image as sent
                            ImageGeneration::where('id', $item->id)->update(['sent' => 1]);
                            
                            $i++;
                        }
                    }
                }

                // Check if all images for this task are sent
                $remainingImages = ImageGeneration::where('taskid', $task->id)->where('sent', 0)->count();
                
                if ($remainingImages == 0) {
                    // Update task status to Success only when all images are sent
                    $task->remark = 'Success - All Images Sent';
                    $task->sent_status = 1;
                    $task->save();
                }

                DB::commit();

                return response()->json(['success' => true, 'message' => 'Task sent successfully.', 'data' => $data]);
            }

            return response()->json(['success' => false, 'message' => 'Task not found or not finished.']);
        } catch (\Exception $e) {
            DB::rollBack();
            
            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Send Task';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();
            
            return response()->json(['success' => false, 'message' => 'Error sending task: ' . $e->getMessage()]);
        }
    }


    public function deleteTask($id)
    {
        $task = Task::find($id);

        if ($task) {
            $beforeGeneration = BeforeGenerate::where('taskid', $task->id)->get();

            foreach ($beforeGeneration as $bg) {
                $imagePath = public_path('img/background_image/' . $bg->backgroundimage);
                if (File::exists($imagePath)) {
                    File::delete($imagePath);
                }
                $bg->delete();
            }

            $task->delete();
            return response()->json(['success' => 'Task deleted successfully'], 200);
        } else {
            return response()->json(['error' => 'Task not found'], 404);
        }
    }



    public function getTaskDetails($id)
    {

         $taskDetails = BeforeGenerate::select(
            'before_genration.status',
            'before_genration.sent_status',
            'before_genration.updated_at',
            'before_genration.id as bfid',
            'before_genration.taskid',
            'templates.name',
            DB::raw('count(generated_image.beforeid) as task_count')
        )
            ->where('before_genration.taskid', $id)
            ->join('templates', 'before_genration.mastertemplateid', '=', 'templates.id')
            ->join('generated_image', 'before_genration.id', '=', 'generated_image.beforeid')

            ->groupBy('before_genration.status', 'before_genration.updated_at', 'before_genration.id', 'before_genration.taskid', 'templates.name','before_genration.sent_status')
            ->get();

        if ($taskDetails) {
            return response()->json(['success' => true, 'data' => $taskDetails]);
        }

        return response()->json(['success' => false, 'message' => 'No details found for the given task ID.']);
    }

    public function getUserDetails($bef_id)
    {


        $beforeid = beforegenerate::find($bef_id);
        $userDetails = ImageGeneration::select('generated_image.genarted_image', 'generated_image.sent', 'customers.name')
            ->join('before_genration', 'before_genration.id', '=', 'generated_image.beforeid')
            ->join('customers', 'customers.id', '=', 'generated_image.customer_id')
            ->where('before_genration.id', $bef_id)
            ->get();



        // dd($userDetails);

        if ($userDetails) {
            return response()->json(['success' => true, 'data' => $userDetails]);
        } else {
            return response()->json(['success' => false]);
        }
    }
    
    
    public function deleteOldImages()
    {
        ImageGeneration::deleteOldImages();

        return response()->json(['success' => 'Old images deleted successfully.']);
    }
}
