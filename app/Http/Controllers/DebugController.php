<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DebugController extends Controller
{
    public function testCustomers()
    {
        $userId = Auth::id();
        $userName = Auth::user()->name;
        $userIdString = (string) $userId;

        $allCustomers = \App\Models\Customer::all();
        
        $customersByUserId = \App\Models\Customer::where('created_by', $userId)->get();
        $customersByUserIdString = \App\Models\Customer::where('created_by', $userIdString)->get();
        $customersByUserName = \App\Models\Customer::where('created_by', $userName)->get();

        return response()->json([
            'current_user' => [
                'id' => $userId,
                'id_string' => $userIdString,
                'name' => $userName,
            ],
            'all_customers' => $allCustomers->map(function($c) {
                return [
                    'id' => $c->id,
                    'name' => $c->name,
                    'email' => $c->email,
                    'created_by' => $c->created_by,
                    'created_by_type' => gettype($c->created_by),
                ];
            }),
            'by_user_id' => $customersByUserId->count(),
            'by_user_id_string' => $customersByUserIdString->count(),
            'by_user_name' => $customersByUserName->count(),
        ]);
    }
}
