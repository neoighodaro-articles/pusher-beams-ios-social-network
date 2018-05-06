<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Photo extends Model
{
    /**
     * Allow mass-assignment of these columns
     */
    protected $fillable = ['user_id', 'caption', 'image', 'image_path'];

    /**
     * Dont add these columns when returning results.
     */
    protected $hidden = ['image_path'];

    /**
     * Relationships to eager load.
     */
    protected $with = ['user', 'comments'];

    /**
     * Defines the relationship with the User model.
     */
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Defines the relationship with the PhotoComment model.
     */
    public function comments()
    {
        return $this->hasMany(PhotoComment::class)->orderBy('id', 'desc');
    }
}
