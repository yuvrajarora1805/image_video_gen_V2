<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Template;
use App\Models\TemplatesByUser;
use App\Models\Tempstore;
use Illuminate\Support\Facades\File;

class TempFormController extends Controller
{


    // Store temporary data
    public function storeTempData(Request $request)
    {
        // Determine content type based on file type
        $contentType = 'image'; // default
        $fileField = 'image';
        $validationRules = [
            'option' => 'required',
        ];

        // Check if video file is uploaded
        if ($request->hasFile('video')) {
            $contentType = 'video';
            $fileField = 'video';
            $validationRules['video'] = 'required|mimes:mp4,mov,avi,wmv|max:512000'; // 500MB max
            $validationRules['option'] = 'required|exists:video_templates,id';
        } else {
            $validationRules['image'] = 'required|image|mimes:jpeg,png,jpg,gif,svg|max:5048';
            $validationRules['option'] = 'required|exists:templates,id';
        }

        $request->validate($validationRules);

        // Find template based on content type
        if ($contentType === 'video') {
            $template = \App\Models\VideoTemplate::find($request->option);
        } else {
            $template = Template::find($request->option);
        }

        if (!$template) {
            return response()->json(['error' => 'Template not found'], 404);
        }

        if (!empty($request->option) && $request->hasFile($fileField)) {
            $file = $request->file($fileField);
            $fileName = ($contentType === 'video' ? 'bg_video_' : 'bg_') . time() . '.' . $file->extension();
            
            // Prevent duplicates: Check if this template is already in the queue
            $existingTemp = Tempstore::where('mastertemplateid', $request->option)
                                     ->where('content_type', $contentType)
                                     ->first();
            if ($existingTemp) {
                return response()->json([
                    'success' => true,
                    'name' => $template->name,
                    'total_count' => TemplatesByUser::where('master_template_id', $request->option)->where('content_type', $contentType)->count(),
                    'message' => 'Template already in queue (Duplicate prevented)'
                ]);
            }

            // Determine upload directory
            $uploadDir = $contentType === 'video' ? 'videos/background_video' : 'img/background_image';
            $file->move(public_path($uploadDir), $fileName);

            $tempData = new Tempstore();
            $tempData->mastertemplateid = $request->option;
            $tempData->backgroundimage = $fileName;
            $tempData->backgroundpath = public_path($uploadDir . '/' . $fileName);
            $tempData->content_type = $contentType;
            if ($contentType === 'video') {
                $tempData->video_type = $template->video_type ?? 'landscape';
                $tempData->animation_effect = $request->input('animation_effect', 'wipe-in');
                $tempData->rendering_engine = $request->input('rendering_engine', 'ffmpeg');
            }
            $tempData->save();

            $name = $template->name;
            $total_count = TemplatesByUser::where('master_template_id', $tempData->mastertemplateid)
                ->where('content_type', $contentType)
                ->count();
        } else {
            return response()->json(['error' => 'Something went wrong !! Try again'], 404);
        }

        return response()->json([
            'success' => true, 
            'id' => $tempData->id, 
            'name' => $name,
            'total_image' => $total_count,
            'content_type' => $contentType
        ], 200);
    }

    public function deleteTempData(Request $request)
    {
        $tempData = Tempstore::find($request->id);

        if ($tempData) {
            // Delete the file from storage
            $fileDir = $tempData->content_type === 'video' ? 'videos/background_video' : 'img/background_image';
            $filePath = public_path($fileDir . '/' . $tempData->backgroundimage);
            
            if (File::exists($filePath)) {
                File::delete($filePath);
            }

            // Delete the record from the database
            $tempData->delete();

            return response()->json(['success' => 'Data deleted successfully'], 200);
        } else {
            return response()->json(['error' => 'Data not found'], 404);
        }
    }
}
