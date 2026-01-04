<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Auth\Events\PasswordReset;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Str;
use App\Models\User;
use Carbon\Carbon;

use Illuminate\Support\Facades\DB;

class ResetPasswordController extends Controller
{

    public function create(Request $request)
    {
        return view('auth.passrecover.reset-password', ['request' => $request]);
    }

    public function store(Request $request)
    {
    
        $request->validate([
            'token' => 'required',
            
            'password' => 'required|string|confirmed|min:8',
        ]);


        DB::beginTransaction();
        try {
            $user = User::where('remember_token', $request->token)->first();
        
            if (!$user || Carbon::now()->greaterThan($user->tokenexpire)) {
                dd($user);
                DB::rollback();
                return redirect('sign-in')->with('error', 'Invalid or expired token!');
            }

         
    
            $user->password = Hash::make($request->password);
            $user->remember_token = null;
            $user->tokenexpire = null;
            $user->save();
    
            DB::commit();
    
            return redirect('sign-in')->with('success', 'Password reset successfully!');
        } catch (\Exception $e) {
            DB::rollback();
            return redirect('sign-in')->with('error', 'An error occurred while processing your request.');
        }

           }
}
