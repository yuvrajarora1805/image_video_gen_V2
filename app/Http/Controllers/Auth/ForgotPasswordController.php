<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;
use Illuminate\Support\Facades\DB;
use App\Models\Errorlogs;
use App\Models\Logs;
use App\Models\User;
use Carbon\Carbon;

class ForgotPasswordController extends Controller
{
    public function create()
    {
        return view('auth.passrecover.forgot-password');
    }

    public function store(Request $request)
    {
        $request->validate(['email' => 'required|email']);

        DB::beginTransaction();
        try {
            $user = User::where('email', $request->email)->first();
    
            if ($user) {
                // Generate reset token and expiry time
                $reset_token = bin2hex(random_bytes(16));
                $token_expiry = Carbon::now()->addMinutes(15);
    
                // Update user's reset token and expiry time
                $user->remember_token = $reset_token;
                $user->tokenexpire = $token_expiry;
                $user->save();
    
                // Generate reset password link
                $reset_link = route('password.reset', ['token' => $reset_token]);

               $emp_email = $user->email;
    
               
                DB::commit();
                $org_log = 'https://rannlab.com/wp-content/uploads/2024/01/Rannlab-logo67-01.png';
                $org_name = 'UVA Creation';
                $this->sendMail($emp_email, $org_log, $reset_link);
               
    
                return redirect()->route('password.request')->with('success', 'Password reset link sent to your registered email address.'.$reset_link);
            } else {
                DB::rollback();
                return redirect()->route('password.request')->with('error', 'User not found.');
            }
        } catch (\Exception $e) {
            DB::rollback();
            return redirect()->route('password.request')->with('error', 'An error occurred while processing your request.');
        }
    
    }

    public function sendMail($emp_email, $org_log, $reset_link)
	{
		$url = 'https://2faotp.com/v1/2FA/SendDynamicEmail';
		/* eCurl */
		$curl = curl_init($url);
		$data = array(
			'EmailTemplateName' => 'UAVForgetPassword', // Change the template name according to your email template
			"SendToEmail" => $emp_email,
			"SendCC" => "vivek.prajpati@rannlab.com", // Add CC email if needed
			'VariableList' => array(
				array(
					"VariableName" => "@rannlab-lms-logo-custom-url",
					"VariableValue" => $org_log
				),
			
				array(
					"VariableName" => "@base_url",
					"VariableValue" => $reset_link
				),
				
			)
		);
		$json = json_encode($data);

		/* Set JSON data to POST */
		curl_setopt($curl, CURLOPT_POSTFIELDS, $json);

		/* Define content type */
		curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-Type:application/json'));

		/* Return json */
		curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

		/* make request */
		$curl_result = curl_exec($curl);

		/* close curl */
		curl_close($curl);
	}

}
