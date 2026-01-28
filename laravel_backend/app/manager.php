<?php

namespace App;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;


class Manager extends Authenticatable
{
    
    use HasApiTokens, Notifiable;
    protected $guard = 'manager';
    protected $fillable = ['nom','prenom','num_tel','password','adresse','email'];
    public $timestamps = false;
    protected $hidden=[
        'password',
    ];
}
