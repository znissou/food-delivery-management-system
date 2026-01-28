<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;


class Client extends Authenticatable
{
    
    use HasApiTokens, Notifiable;
    protected $guard = 'client';
    protected $fillable = ['nom','prenom','tel','password','adresse','email'];
    public $timestamps = false;
    protected $hidden=[
        'password',
    ];
}
