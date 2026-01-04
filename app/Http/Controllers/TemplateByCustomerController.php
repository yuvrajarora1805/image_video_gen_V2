<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use App\Models\Template;
use App\Models\VideoTemplate;
use App\Models\TemplatesByUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Errorlogs;
use App\Models\Logs;

class TemplateByCustomerController extends Controller
{
    // public function index()
    // {


    //     $data = TemplatesByUser::select('templates_by_user.*','customers.name','templates.name as templatename')-> join('templates', 'templates_by_user.master_template_id','=','templates.id')->
        
    //     join('customers', 'templates_by_user.customer_id','=','customers.id')->paginate(100);
    //     //    dd($data);
    //     return view('template-user.index', compact('data'));
    // }

    public function index(Request $request)
    {
        if ($request->ajax()) {
            try {
                $query = TemplatesByUser::select('templates_by_user.*');
        
                // Check if search query is present
                if ($request->has('search') && $request->search != '') {
                    $search = $request->search;
                    $query->where(function($q) use ($search) {
                        $q->where('customer_id', 'like', "%$search%")
                          ->orWhere('master_template_id', 'like', "%$search%");
                    });
                }
        
                $templates = $query->orderBy('id', 'desc')->paginate(10);
                
                // Manually fetch related data to avoid memory issues
                $data = [];
                foreach ($templates as $item) {
                    $customer = Customer::find($item->customer_id);
                    
                    if ($item->content_type === 'video') {
                        $template = VideoTemplate::find($item->master_template_id);
                    } else {
                        $template = Template::find($item->master_template_id);
                    }
                    
                    $data[] = [
                        'id' => $item->id,
                        'name' => $customer ? $customer->name : 'Unknown',
                        'templatename' => $template ? $template->name : 'Unknown',
                        'template_path' => $item->template_path,
                        'content_type' => $item->content_type ?? 'image',
                        'created_at' => $item->created_at->format('d M Y'),
                    ];
                }
        
                return response()->json([
                    'data' => $data,
                    'pagination' => $templates->links()->render()
                ]);
            } catch (\Exception $e) {
                return response()->json([
                    'error' => true,
                    'message' => $e->getMessage()
                ], 500);
            }
        } else {
            return view('template-user.index');
        }
    }
    


    public function showCreateForm()
    {
        $templates = Template::get();
        $videoTemplates = VideoTemplate::get();
        $customers = Customer::orderBy('id', 'desc')->get();
        

        return view('template-user.assign-templates', compact('templates', 'videoTemplates', 'customers'));
    }

    // public function store(Request $request)
    // {

    //     $request->validate([
    //         'master_template' => 'required',
    //         'user' => 'required',
    //         'user_template' => 'required|file|mimes:jpeg,png,jpg,pdf,doc,docx',
    //     ]);

    

    //     if ($request->user_template) {

    //         $exist = TemplatesByUser::where('customer_id' ,$request->user)->first();

    //         if($exist)
    //         {
    //             $imageFile = $request->file('user_template');
    //             $mime = $imageFile->getClientOriginalExtension();
               
    //             $imageName = 'user_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
            
    //             $imagePath = 'img/user_template/' . $imageName;
    //             $imageFile->move(public_path('img/user_template'), $imageName);
            
                
    //             $exist->master_template_id = $request->master_template;
    //             $exist->customer_template = $imageName;
    //             $exist->template_path = $imagePath;
    //             $exist->memtype = $mime; 
            
    //             $exist->save();

               
    //             return redirect('assign')->with('success', 'Template Updated Successfully !!!');
                
    //         }
    //         else{
    //             $imageFile = $request->file('user_template');
    //             // $templateCount = TemplatesByUser::count() + 1;
    //             $mime = $imageFile->getClientOriginalExtension();

    //             $imageName = 'user_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
    //             // $imageName = 'user_template_' . str_pad($templateCount, 2, '0', STR_PAD_LEFT) . '.' . $imageFile->getClientOriginalExtension();
    
    //             $imagePath = 'img/user_template/' . $imageName;
    //             $imageFile->move(public_path('img/user_template'), $imageName);
    //             // $path = $request->file('user_template')->store('customer_templates');
    //             $user_template = new TemplatesByUser();
    //             $user_template->master_template_id = $request->master_template;
    //             $user_template->customer_id = $request->user;
    //             $user_template->customer_template = $imageName;
    //             $user_template->template_path = $imagePath;
    //             $user_template->memtype = $mime;
    //             $user_template->save();
    
    //             return redirect('assign')->with('success', 'Template Assigned Successfully !!!');
    //         }
            
    //     }

    //     return redirect('assign')->with('error', 'Template Assigned Failed !!!');
    // }


 public function store(Request $request)
{
    try {
        DB::beginTransaction();

        $request->validate([
            'master_template' => 'required',
            'template_type' => 'required|in:image,video',
            'user' => 'required',
            'user_template' => 'required|file|mimes:jpeg,png,jpg,pdf,doc,docx',
        ]);

        if ($request->user_template) {
            $imageFile = $request->file('user_template');
            $mime = $imageFile->getClientOriginalExtension();
            $imageName = 'user_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
            $imagePath = 'img/user_template/' . $imageName;
            $imageFile->move(public_path('img/user_template'), $imageName);

            // Always create new template assignment (allow multiple templates per customer)
            $user_template = new TemplatesByUser();
            $user_template->master_template_id = $request->master_template;
            $user_template->customer_id = $request->user;
            $user_template->customer_template = $imageName;
            $user_template->template_path = $imagePath;
            $user_template->memtype = $mime;
            $user_template->content_type = $request->template_type;
            $user_template->save();

            $logs = new Logs();
            $logs->task_id = $user_template->id;
            $logs->status = 'success';
            $logs->message = 'Customer Template created successfully';
            $logs->save();
        }

        DB::commit();

        return redirect('assign')->with('success', 'Template assigned successfully! You can assign more templates to the same customer.');
    } catch (\Exception $e) {
        DB::rollBack();

        $errorlogs = new Errorlogs();
        $errorlogs->action = 'Customer Template Creation';
        $errorlogs->message = $e->getMessage();
        $errorlogs->save();

        return redirect('assign')->with('error', 'An error occurred while processing the request: ' . $e->getMessage());
    }
}

  public function destroy($id)
    {
        try {
            $item = TemplatesByUser::findOrFail($id);
            $item->delete();

            return response()->json(['success' => 'Item deleted successfully.']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Item not found or could not be deleted.'], 404);
        }
    }
    

//     public function store(Request $request)
// {
//     try {
//         $request->validate([
//             'master_template' => 'required',
//             'user' => 'required',
//             'user_template' => 'required|file|mimes:jpeg,png,jpg,pdf,doc,docx',
//         ]);

//         if ($request->user_template) {
//             $exist = TemplatesByUser::where('customer_id', $request->user)->first();

//             if ($exist) {
//                 $imageFile = $request->file('user_template');
//                 $mime = $imageFile->getClientOriginalExtension();
//                 $imageName = 'user_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
//                 $imagePath = 'img/user_template/' . $imageName;
//                 $imageFile->move(public_path('img/user_template'), $imageName);

//                 $exist->master_template_id = $request->master_template;
//                 $exist->customer_template = $imageName;
//                 $exist->template_path = $imagePath;
//                 $exist->memtype = $mime;
//                 $exist->save();

//                 return redirect('assign')->with('success', 'Template Updated Successfully !!!');
//             } else {
//                 $imageFile = $request->file('user_template');
//                 $mime = $imageFile->getClientOriginalExtension();
//                 $imageName = 'user_template_' . time() . '_' . uniqid() . '.' . $imageFile->getClientOriginalExtension();
//                 $imagePath = 'img/user_template/' . $imageName;
//                 $imageFile->move(public_path('img/user_template'), $imageName);

//                 $user_template = new TemplatesByUser();
//                 $user_template->master_template_id = $request->master_template;
//                 $user_template->customer_id = $request->user;
//                 $user_template->customer_template = $imageName;
//                 $user_template->template_path = $imagePath;
//                 $user_template->memtype = $mime;
//                 $user_template->save();

//                 return redirect('assign')->with('success', 'Template Assigned Successfully !!!');
//             }
//         }
//     } catch (\Exception $e) {
//         return redirect('assign')->with('error', 'An error occurred while processing the request: ' . $e->getMessage());
//     }

//     return redirect('assign')->with('error', 'Template Assigned Failed !!!');
// }

}
