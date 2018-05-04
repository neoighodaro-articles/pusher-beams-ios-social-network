<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class UserSetting extends Model
{
    protected $fillable = [
        'notification_likes', 'notification_comments', 'notification_followers'
    ];

    protected $hidden = ['id', 'user_id'];

    public $timestamps = false;

    public function scopeForCurrentUser($query)
    {
        return $query->where('user_id', auth()->user()->id);
    }
}
