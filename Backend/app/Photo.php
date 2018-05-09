<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Photo extends Model
{
    protected $hidden = ['image_path'];

    protected $with = ['user', 'comments'];

    protected $fillable = ['user_id', 'caption', 'image', 'image_path'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function comments()
    {
        return $this->hasMany(PhotoComment::class)->orderBy('id', 'desc');
    }
}
