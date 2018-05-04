<?php

namespace App\Http\Controllers;

use App\Photo;
use App\PhotoLike;
use Illuminate\Http\Request;

class PhotoLikeController extends Controller
{
    public function store(Request $request, Photo $photo)
    {
        $photo->likes()->save(new PhotoLike(['user_id' => $request->user()->id]));

        return response()->json(['status' => 'success']);
    }

    public function destroy(Request $request, Photo $photo)
    {
        PhotoLike::wherePhotoId($photo->id)->whereUserId($request->user()->id)->delete();

        return response()->json(['status' => 'success']);
    }
}
