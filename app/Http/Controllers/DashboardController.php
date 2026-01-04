<?php

namespace App\Http\Controllers;

use App\Models\Customer;
use App\Models\ImageGeneration;
use App\Models\Task;
use Illuminate\Http\Request;
use Carbon\Carbon;

class DashboardController extends Controller
{
    public function index()
    {

        $totol_customers = Customer::count();
        $totoal_task = Task::count();
        $complete_task = Task::where('status', 1)->count();
        $pending_task = Task::where('status', 0)->count();
        $total_gnerate = ImageGeneration::count();
         $total_sent = ImageGeneration::where('sent',1)->count();
        // dd($totoal_customers);

        // 
        $today_generate = ImageGeneration::
            select('customers.name', 'generated_image.genarted_image','generated_image.created_at','generated_image.sent')
            ->join('customers', 'generated_image.customer_id', '=', 'customers.id')
            ->whereDate('generated_image.created_at', Carbon::today())
            ->orderBy('generated_image.id', 'DESC')
            ->paginate(50);
        // dd($today_generate);
        return view('dashboard' , compact('totol_customers' ,'totoal_task' ,'complete_task','pending_task','total_gnerate','today_generate','total_sent'));
    }
}
