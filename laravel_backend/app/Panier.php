<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Panier extends Model
{
    public $timestamps = false;
    protected $fillable = ['quantite', 'id_client', 'id_repas'];
}
