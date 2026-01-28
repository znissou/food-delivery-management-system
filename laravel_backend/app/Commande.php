<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Commande extends Model
{
    protected $fillable = ['id_client', 'id_restaurant','prix_totale','adresse_livraison','etat'];
}
