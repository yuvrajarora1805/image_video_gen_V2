<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Errorlogs;
use App\Models\Logs;
use Illuminate\Support\Facades\File;
use App\Models\TemplatesByUser;
use App\Models\ImageGeneration;

class CustomerController extends Controller
{

 


    public function index(Request $request)
    {
        if ($request->ajax()) {
            $query = Customer::query();

            if ($request->has('search') && $request->search != '') {
                $search = $request->search;
                $query->where('name', 'LIKE', "%$search%")
                    ->orWhere('whatsappgroup', 'LIKE', "%$search%");
            }

            $users = $query->orderBy('id', 'DESC')->paginate(50);

            // Format created_at date
            $users->getCollection()->transform(function ($user) {
                $user->formatted_date = \Carbon\Carbon::parse($user->created_at)->format('d-m-Y - H:i A');
                return $user;
            });

            return response()->json([
                'data' => $users->items(),
                'pagination' => $users->appends(request()->input())->links()->render()
            ]);
        } else {
            return view('customers.users-management');
        }
    }




    public function create_user(Request $request)
    {
        DB::beginTransaction();

        try {
            if (!empty($request->name)) {
                $name = $request->name;
                // $mobile = $request->mobile;
                $group = $request->groupname;

                // Check if a customer with the same name and WhatsApp group already exists
                $existingCustomer = Customer::where('name', $name)
                    ->where('whatsappgroup', $group)
                    ->first();

                if ($existingCustomer) {
                    return redirect('users-management')->with('error', "Customer .$name. with the .$group. WhatsApp group already exists.");
                }

                $Customer = new Customer();
                $Customer->name = $name;
                // $Customer->mobile = $mobile;
                $Customer->whatsappgroup = $group;
                $Customer->save();

                // Log success
                $logs = new Logs();
                $logs->task_id = $Customer->id;
                $logs->status = 'success';
                $logs->message = 'Customer created successfully';
                $logs->save();

                DB::commit();

                return redirect('users-management')->with('success', "Customer Created Successfully !!!");
            }
        } catch (\Exception $e) {
            DB::rollBack();

            // Log error
            $errorlogs = new Errorlogs();
            $errorlogs->action = 'Customer Creation';
            $errorlogs->message = $e->getMessage();
            $errorlogs->save();

            return redirect('users-management')->with('error', "An error occurred while creating the customer.");
        }

        return view('customers.create-user');
    }


    public function customername(Request $request)
    {

        $query = Customer::select('name');


        if ($request->name) {
            $query->where('name', $request->name);
        }
        if ($request->mobile) {

            $query->where('mobile', $request->mobile);
        }
        if ($request->group) {
            $query->where('whatsappgroup', $request->group);
        }

        $result = $query->paginate(20);

        return response($result);
    }

    public function customermobile(Request $request)
    {

        $query = Customer::select('mobile');


        if ($request->name) {
            $query->where('name', $request->name);
        }
        if ($request->mobile) {

            $query->where('mobile', $request->mobile);
        }
        if ($request->group) {
            $query->where('whatsappgroup', $request->group);
        }

        $result = $query->paginate(20);

        return response($result);
    }

    public function customergroup(Request $request)
    {

        $query = Customer::select('whatsappgroup');


        if ($request->name) {
            $query->where('name', $request->name);
        }
        if ($request->mobile) {

            $query->where('mobile', $request->mobile);
        }
        if ($request->group) {
            $query->where('whatsappgroup', $request->group);
        }

        $result = $query->paginate(20);

        return response($result);
    }
    
    
    
    public function destroy($id)
    {
        try {
            
            $customer = Customer::findOrFail($id);

            
            $items = TemplatesByUser::where('customer_id', $id)->get();
            foreach ($items as $item) {
                $item->delete();
            }

            
            $generatedImages = ImageGeneration::where('customer_id', $id)->get();
            foreach ($generatedImages as $img) {
                $imagePath = public_path('img/generated_image/' . $img->image_name);

                
                if (File::exists($imagePath)) {
                    File::delete($imagePath);
                }

                
                $img->delete();
            }

          
            $customer->delete();

            return response()->json(['success' => 'Customer and related items deleted successfully.']);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Customer not found or could not be deleted.'], 404);
        }
    }

}
