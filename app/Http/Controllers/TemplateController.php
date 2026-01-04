<?php

namespace App\Http\Controllers;

use App\Models\Template;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;
use App\Models\Errorlogs;
use App\Models\Logs;

// use Intervention\Image\Facades\Image;

class TemplateController extends Controller
{


    // public function index()
    // {

    //     $data = Template::paginate(15);
    //     // dd($data);
    //     return view('master-template.index',compact('data'));
    // }

    public function index(Request $request)
    {
        if ($request->ajax()) {
            // $query = Template::query();
             $query = Template::withUserCount();

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
            return view('master-template.index');
        }
    }


    public function showCreateForm()
    {
        return view('master-template.create-templates');
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'image' => 'required|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
        ]);

        try {
            // Begin transaction
            DB::beginTransaction();

            // Check if template with the same name already exists
            $existingTemplate = Template::where('name', $request->name)->first();
            if ($existingTemplate) {
                // If template with the same name exists, rollback transaction
                DB::rollBack();
                return redirect()->back()->with('error', $request->name.' Template already exists.');
            }

            if (!empty($request->image)) {
                // Generate a unique image name
                $imgName = 'template_' . time() . '_' . uniqid() . '.' . $request->file('image')->getClientOriginalExtension();

                // Save the image to the public/img/master_template directory
                $outputPath = public_path('img/master_template/' . $imgName);
                $request->file('image')->move(public_path('img/master_template'), $imgName);

                // Save the template details to the database
                $template = new Template();
                $template->name = $request->name;
                $template->path = $outputPath;  // Save the image path
                $template->image = $imgName;  // Save the image name
                $template->memtype = $request->file('image')->getClientOriginalExtension();  // Assuming memtype is same as file extension
                $template->save();

                // Commit transaction
                DB::commit();

                // Store logs
                $logs = new Logs();
                $logs->task_id = $template->id; // Assuming task_id is the template id
                $logs->status = 'success';
                $logs->message = 'Template created successfully';
                $logs->save();

                return redirect('template')->with('success', 'Template Created Successfully !!!');
            }
        } catch (\Exception $e) {
            // Rollback transaction in case of any exception
            DB::rollBack();

            // Store error logs
            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Template Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();

            return redirect()->back()->with('error', 'Failed to create template.');
        }

        return redirect()->back()->with('error', 'Failed to create template.');
    }

    /**
     * Delete master template
     */
    public function destroy($id)
    {
        try {
            DB::beginTransaction();

            $template = Template::findOrFail($id);
            
            // Check if template is being used
            $usageCount = \App\Models\TemplatesByUser::where('master_template_id', $id)
                ->where('content_type', 'image')
                ->count();
            
            if ($usageCount > 0) {
                return response()->json([
                    'success' => false,
                    'message' => 'Cannot delete template. It is assigned to ' . $usageCount . ' customer(s).'
                ], 400);
            }

            // Delete image file
            $imagePath = public_path('img/master_template/' . $template->image);
            if (File::exists($imagePath)) {
                File::delete($imagePath);
            }

            $template->delete();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Template deleted successfully'
            ]);
        } catch (\Exception $e) {
            DB::rollBack();
            
            return response()->json([
                'success' => false,
                'message' => 'Error deleting template: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getTemplateImage($id)
    {
        $template = Template::find($id);

        if ($template) {
            return response()->json(['image' => $template->image], 200);
        } else {
            return response()->json(['error' => 'Template not found'], 404);
        }
    }
}
