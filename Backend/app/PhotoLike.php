<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PhotoLike extends Model
{
    protected $fillable = ['user_id', 'photo_id'];
}
