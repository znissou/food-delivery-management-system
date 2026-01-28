<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Commande;
use App\Panier;
use App\Repa;
use App\Ligne;
use App\Token;
use App\Restaurant;

class CommandeController extends Controller
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
     *
     */
    public function create(Request $request)
    {
        $request->validate([
            'adresse'=>'required',
        ]);

        $id=$request->user()->id;
    
        $join=Repa::join('paniers','ID',"=",'paniers.id_repas')
        ->orderBy('ID_restaurant')
        ->get();
        foreach($join as $panier){
            if($panier->quantite>$panier->disponible){
                return response($panier->nom.' non disponible',400);
            }
        }
        
        $last_res=0;

        foreach($join as $rest){
        if ($rest->ID_restaurant!=$last_res){
            
            $cmnd=Commande::create([
                'id_client'=>$id,
                'adresse_livraison'=>$request->adresse,
                'id_restaurant'=>$rest->ID_restaurant,
                'prix_totale'=>0

            ]);
            $last_res=$rest->ID_restaurant;
           
        }
        Ligne::create([
            'id_commande'=>$cmnd->id,
            'id_repas'=>$rest->ID,
            'quantite'=>$rest->quantite
                        ]);  
 
        $cmnd->prix_totale= $cmnd->prix_totale+($rest->prix*$rest->quantite);
        $cmnd->save();
    }
        Panier::where('id_client',$id)->delete();
       return response('done!',200);
    
}



   
    public function show(Request $request)
    {
        
        $id_client=$request->user()->id;
        $commandes=Commande::where('id_client',$id_client)->get();
        foreach($commandes as $commande){
            $restaurant=Restaurant::where('ID',$commande->id_restaurant)->first();
            $commande->restaurant=$restaurant->nom;
        }
        return response(json_encode($commandes),200);
    }

    public function showOrder(Request $request){
        $request->validate([
            'id_commande'=>'required'
        ]);
        $join=Ligne::join('repas','id_repas',"=",'repas.ID')
       ->where('id_commande',$request->id_commande)
       ->get();
       return response(json_encode($join),200);
    }

    public function showRestaurantOrder(Request $request){
        
        $manager=$request->user()->id;
        $join=Commande::where('id_restaurant',$manager)
        ->orderBy('commandes.ID','desc')
        ->join('clients','id_client',"=",'clients.id')
        ->get();
$response=[];
       foreach($join as $cmnd){
array_push($response,[
    
        'tel'=>$cmnd->tel,
        'prenom'=>$cmnd->prenom,
        'nom'=>$cmnd->nom,
        'prix_totale'=>$cmnd->prix_totale,
        'adresse'=>$cmnd->adresse_livraison,
        'etat'=>$cmnd->etat,
        'id'=>$cmnd->ID
               
]);
       }
        
        return response(json_encode($response),200);


    }

    public function updateEtat(Request $request){
        $request->validate([
            'id'=>'required',
            'etat'=>'required'
        ]);
        Commande::where('ID',$request->id)->update([
            'etat'=>$request->etat
        ]);
        if($request->etat==2){
$join=Ligne::join('repas','id_repas',"=",'repas.ID')
->where('id_commande',$request->id)
->get();
foreach($join as $edit){
    if($edit->quantite<$edit->disponible){
    Repa::where('ID',$edit->id_repas)->update([
        'disponible'=>$edit->disponible-$edit->quantite,
    ]);
}else{
    return response('repas non disponible',400);
}
}
        }
        /* Repa::where('ID',$rest->ID)->update(['disponible'=>$rest->disponible-$rest->quantite]);*/
        return response('done!',200);
    }
    
     
}
