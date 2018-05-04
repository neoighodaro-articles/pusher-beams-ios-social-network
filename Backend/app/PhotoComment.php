<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class PhotoComment extends Model
{
    protected $fillable = ['photo_id', 'user_id', 'comment'];

    protected $with = ['user'];

    public function scopeForPhoto($query, int $id)
    {
        return $query->where('photo_id', $id);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
