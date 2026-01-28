<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Restaurant;
use App\Token;

class RestaurantController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        $result = Restaurant::all();
      return json_encode($result);
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show(Request $request)
    {
       $manager=$request->user()->id;
        $Response=Restaurant::where('ID',$manager)->first();
        return response(json_encode($Response),200);
    }

    public function updateEtat(Request $request){
        $request->validate([
            'etat'=>'required'
        ]);
        $manager=$request->user()->id;
        $update=Restaurant::where('ID',$manager)->update(['etat'=>$request->etat]);
        return 200;
    }

    public function updateTel(Request $request){
        $request->validate([
            
            'tel'=>'required'
        ]);
        $manager=$request->user()->id;
        $restaurant=Restaurant::where('ID',$manager)->update([
            'tel'=>$request->tel
        ]);
        return response('done!',200);
    }

    public function updateAdresse(Request $request){
        $request->validate([
            'adresse'=>'required'
        ]);
        $manager=$request->user()->id;
        $restaurant=Restaurant::where('ID',$manager)->update([
            'adresse'=>$request->adresse
        ]);
        return response('done!',200);
    }
    public function fetchImage($id){

        return Storage::download('public/images/restaurant/'.$id.'.png');

    }
}
