<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;

class PhotoComment extends Model
{
    use Notifiable;

    protected $with = ['user'];

    protected $fillable = ['photo_id', 'user_id', 'comment'];

    public function scopeForPhoto($query, int $id)
    {
        return $query->where('photo_id', $id);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
