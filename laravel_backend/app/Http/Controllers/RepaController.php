<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Intervention\Image\Facades\Image;
use Illuminate\Support\Facades\Storage;
use App\Repa;
use App\Token;

class RepaController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $result = Repa::all();
      return json_encode($result);
    }

    public function showRestaurantRepas1($id){/////////////////////////pour un client
        $result = Repa::where('ID_restaurant',$id)->get();
        return json_encode($result,200);
    }

    public function showRestaurantRepas2(Request $request){/////////////////////////pour un manager
     
        $managerId=$request->user()->id;
        $repas = Repa::where('ID_restaurant',$managerId)->get();
        return json_encode($repas,200);
    }






    public function store(Request $request)
    {
        $request->validate([
           'nom'=>'required',
           'ingredients'=>'required',
           'prix'=>'required',
          
        ]);

        if ($request->hasFile('image')) {

    

        $request->user()->id;
        $meal = Repa::create([
            'nom'=>$request->nom,
            'ingredients'=>$request->ingredients,
            'prix'=>$request->prix,
            'ID_categorie'=>1,
            'ID_restaurant'=>$request->user()->id 
        ]);

            $originalImage = $request->file('image');
            
            $resizedImage = Image::make($originalImage);
            $resizedImage->resize(null, 200, function ($constraint) {
                $constraint->aspectRatio();
            });
        
            $resizedImage->stream();

            Storage::disk('local')->put('public/images/meal/'. $meal->id.'.png', $resizedImage, 'public');

        }else{return response('image required !',400);}
        return response($meal, 201);
    }

    public function fetchImage($id){

        return Storage::download('public/images/meal/'.$id.'.png');

    }
    

    public function show($id)
    {
        return Repa::where('ID',$id)->first();
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function editPrix(Request $request)////// not tested
    {
        $request->validate([
            'id'=>'required',
            'prix'=>'required'
        ]);
        Repa::where('ID',$request->id)->update([
            'prix'=>$request->prix
        ]);
        return 200;
    }


    public function editDisponible(Request $request)////// not tested
    {
        $request->validate([
            'id'=>'required',
            'disponible'=>'required'
        ]);
        Repa::where('ID',$request->id)->update([
            'disponible'=>$request->disponible
        ]);
        return 200;
    }
   

   
    public function destroy(Request $request)/////not tested
    {
        $request->validate([
            'id'=>'required'
        ]);
        Repa::where('ID',$request->id)->delete();
        return 200;
    }


   

}