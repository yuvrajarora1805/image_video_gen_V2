<?php

namespace App\Http\Controllers;

use App\Models\VideoTemplate;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use App\Models\Errorlogs;
use App\Models\Logs;

class VideoTemplateController extends Controller
{
    /**
     * Display list of video templates (master templates)
     */
    public function index(Request $request)
    {
        if ($request->ajax()) {
            $query = VideoTemplate::withUserCount();

            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where('name', 'LIKE', "%$search%");
            }

            $templates = $query->orderBy('id', 'DESC')->paginate(50);

            $templates->getCollection()->transform(function ($template) {
                $template->formatted_date = \Carbon\Carbon::parse($template->created_at)->format('d-m-Y - H:i A');
                return $template;
            });

            return response()->json([
                'data' => $templates->items(),
                'pagination' => $templates->appends(request()->input())->links()->render()
            ]);
        } else {
            return view('video-master-template.index');
        }
    }

    /**
     * Show form to create new video template
     */
    public function showCreateForm()
    {
        return view('video-master-template.create-templates');
    }

    /**
     * Store new video template (master template)
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        try {
            DB::beginTransaction();

            // Check if template with same name exists
            $existingTemplate = VideoTemplate::where('name', $request->name)->first();
            if ($existingTemplate) {
                DB::rollBack();
                return redirect()->back()->with('error', $request->name . ' Video template already exists.');
            }

            if (!empty($request->image)) {
                // Generate unique image name
                $imgName = 'video_template_' . time() . '_' . uniqid() . '.' . $request->file('image')->getClientOriginalExtension();

                // Save to public/img/master_template directory (same as image templates)
                $outputPath = public_path('img/master_template/' . $imgName);
                $request->file('image')->move(public_path('img/master_template'), $imgName);

                // Save to database
                $template = new VideoTemplate();
                $template->name = $request->name;
                $template->path = $outputPath;
                $template->image_path = $imgName; // Store filename
                $template->video_file = $imgName; // For compatibility
                $template->memtype = $request->file('image')->getClientOriginalExtension();
                $template->is_active = 1;
                $template->save();

                DB::commit();

                // Log success
                $logs = new Logs();
                $logs->task_id = $template->id;
                $logs->status = 'success';
                $logs->message = 'Video template created successfully';
                $logs->save();

                return redirect()->route('video-template')->with('success', 'Video Template Created Successfully!');
            }
        } catch (\Exception $e) {
            DB::rollBack();

            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Video Template Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();

            return redirect()->back()->with('error', 'Failed to create video template: ' . $e->getMessage());
        }

        return redirect()->back()->with('error', 'Failed to create video template.');
    }

    /**
     * Get template image for preview (AJAX)
     */
    public function getTemplateImage($id)
    {
        try {
            $template = VideoTemplate::findOrFail($id);
            $imagePath = asset('img/master_template/' . $template->image_path);
            
            return response()->json([
                'success' => true,
                'imagePath' => $imagePath,
                'name' => $template->name
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Template not found'
            ], 404);
        }
    }

    /**
     * Delete video template
     */
    public function destroy($id)
    {
        try {
            DB::beginTransaction();

            $template = VideoTemplate::findOrFail($id);
            
            // Check if template is being used
            $usageCount = \App\Models\TemplatesByUser::where('master_template_id', $id)
                ->where('content_type', 'video')
                ->count();
            
            if ($usageCount > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete template. It is assigned to ' . $usageCount . ' customer(s).'
                ], 400);
            }

            // Delete image file
            $imagePath = public_path('img/master_template/' . $template->image_path);
            if (File::exists($imagePath)) {
                File::delete($imagePath);
            }

            $template->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Video template deleted successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            
            return response()->json([
                'success' => false,
                'message' => 'Error deleting template: ' . $e->getMessage()
            ], 500);
        }
    }
}
