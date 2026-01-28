<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\manager;
use App\Token;

class ManagerController extends Controller
{
   public function getManager(Request $request){
    
    $managerEmail=$request->user()->email;
    $manager=manager::where('email', $managerEmail)->first();
    if($manager){
    return response(json_encode($manager),200);
}else{
    return response("manager n'existe pas",400);
}
   }

   public function updateEmail(Request $request){
    $request->validate([
        'email'=>'required'
    ]);
    $managerEmail=$request->user()->email;
    $manager=manager::where('email',$request->email)->first();
    if($manager){
return response('email existe deja ',400);
    }else{
        $manager=manager::where('email',$managerEmail)->update([
            'email'=>$request->email
        ]);
        Token::where('name',$managerEmail)->update([
            'name'=>$request->email
        ]);
        return response('done!',200);
    }
    
   }

   public function updateTel(Request $request){
    $request->validate([
        'tel'=>'required'
    ]);
    $managerEmail=$request->user()->email;
    $manager=manager::where('email',$managerEmail)->update([
        'num_tel'=>$request->tel
    ]);
    return response('done!',200);
   }

   public function updatePassword(Request $request){
    $request->validate([
        'expassword'=>'required',
        'password'=>'required'
    ]);
    $managerEmail=$request->user()->email;
    $manager=manager::where('email',$managerEmail)->first();
    if($manager->password==$request->expassword){
    $manager->update([
        'password'=>$request->password
    ]);
    return response('done!',200);
    }else{
return response('mot de passe incorrect',400);
    }
   

   }
}
