<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use App\Client;
use App\Token;
use App\Manager;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
 public function register(Request $request){

    $request->validate([
        'email' => 'required',
        'password' => 'required',
    ]);

$user=Client::where('email',$request->email)->first();
if($user){
    return response('cet email exist deja', 403);
    

}
$input=$request->all();
$input['password']=Hash::make($input['password']);
$user=Client::create($input);

$token=$user->createToken($request->email)->plainTextToken;
$response['token']=$token;
return response(json_encode($response),201);
   }

public function loginClient(Request $request){
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    $user = Client::where('email', $request->email)->first();

    if (!$user ) {
        return response("utilisateur n'existe pas", 403);
    }
    if( !Hash::check($request->password, $user->password)){
        return response("mot de passe incrorrect", 403);
    }
    $token=$user->createToken($request->email)->plainTextToken;
    $response['token']=$token;
    return response(json_encode($response),200);
}

public function loginManager(Request $request){
    $request->validate([
        'email' => 'required|email',
        'password' => 'required',
    ]);

    $user = Manager::where('email', $request->email)->first();

    if (!$user ) {
        return response("utilisateur n'existe pas", 401);
    }
    if(!Hash::check($request->password, $user->password)){
        return response("mot de passe incrorrect", 400);
    }
    $token=$user->createToken($request->email)->plainTextToken;
    $response['token']=$token;
    return response(json_encode($response),200);
}


}
