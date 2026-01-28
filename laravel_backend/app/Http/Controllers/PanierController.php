<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Panier;
use App\Token;
use App\Repa;
use App\Http\Controllers\RepaController;

class PanierController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        //
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create(Request $request)
    {
        

        $id=$request->user()->id;
        if(Panier::where('id_client',$id)->where('id_repas',$request->id)->first()){
            return response('existe deja dans le panier',404);
      
    }else{
        Panier::create([
            "id_client"=>$id,
            "id_repas"=>$request->id,
            "quantite"=>$request->quantite
        ]);
        return response('tout va bien',201);
    }
        
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request)
    {
        $repas=[];
        $id=$request->user()->id;
        $panier_user=Panier::where('id_client',$id)->get();
        foreach($panier_user as $panier){
            $repa=app('App\Http\Controllers\RepaController')->show($panier->id_repas);
           
            array_push($repas,[
                'quantite'=>$panier->quantite,
                'id_repa'=>$panier->id_repas,
                'id_restaurant'=>$repa->ID_restaurant,
                'nom'=>$repa->nom,
                'prix'=>$repa->prix
            ]);
        }
       return response(json_encode($repas)); 
        
    }

   

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request)
    {
        $id=$request->user()->id;
        Panier::where('id_client',$id)->where('id_repas',$request->id)->update(['quantite' => $request->quantite]);
        return response ('done!',200);
    }

    
    
    public function destroy(Request $request)
    {
        $id=$request->user()->id;
        Panier::where('id_client',$id)->where('id_repas',$request->id)->delete();
        return response('done',200);
    }



}
