<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Ligne extends Model
{
    protected $table = 'commande_ligne';
    protected $fillable = ['id_commande','id_repas','quantite'];
    public $timestamps = false;
}
