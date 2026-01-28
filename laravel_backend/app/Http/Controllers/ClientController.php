<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Client;
use App\Token;
use Illuminate\Support\Facades\Hash;

class ClientController extends Controller
{
   

    /**
     * Display the specified resource.
     *@param  \Illuminate\Http\Request 
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function getClient(Request $request){

       $client=$request->user();
        return response()->json(['success' => true, 'data' => $client], 200);
    }



public function updateTel(Request $request){
    $request->validate([
        'tel'=>'required'
    ]);
    $clientId=$request->user()->id;
    $client=Client::where('id',$clientId)->update([
        'tel'=>$request->tel
    ]);
    return response()->json(['success' => true, 'message' => 'Telephone updated successfully'], 200);
   }


   public function updateEmail(Request $request){
    $request->validate([
        'email'=>'required'
    ]);
    $clientId=$request->user()->id;
    $client=Client::where('email',$request->email)->first();
    if($client){
return response()->json(['success' => false, 'message' => 'Email already exists'], 400);
    }else{
        $client=Client::where('id',$clientId)->update([
            'email'=>$request->email
        ]);
        
        return response()->json(['success' => true, 'message' => 'Email updated successfully'], 200);
    }
}

    public function updatePassword(Request $request){
        $request->validate([
            'expassword'=>'required',
            'password'=>'required'
        ]);
        $clientId=$request->user()->id;
        $client=Client::where('id',$clientId)->first();
        if(Hash::check($request->expassword, $client->password)){
        $client->update([
            'password'=>Hash::make($request->password)
        ]);
        return response()->json(['success' => true, 'message' => 'Password updated successfully'], 200);
        }else{
    return response()->json(['success' => false, 'message' => 'Incorrect password'], 400);
        }
       }


       public function updateAdresse(Request $request){
        $request->validate([
            'adresse'=>'required'
        ]);
        $clientId=$request->user()->id;
        $client=Client::where('id',$clientId)->first();
        
            $client->update([
                'adresse'=>$request->adresse
            ]);
            
            return response()->json(['success' => true, 'message' => 'Address updated successfully'], 200);
        
    }
    
   }







  