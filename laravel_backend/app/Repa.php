<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Repa extends Model
{
    public $timestamps = false;
    protected $fillable = ['nom', 'ingredients', 'ID_restaurant','prix','ID_categorie'];
}
