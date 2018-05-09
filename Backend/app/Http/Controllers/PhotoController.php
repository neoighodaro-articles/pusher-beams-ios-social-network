<?php

namespace App\Http\Controllers;

use App\Photo;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class PhotoController extends Controller
{
    public function index()
    {
        $photos = Photo::orderBy('id', 'desc')->paginate(20);

        return response()->json($photos->toArray());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'caption' => 'required|between:1,1000',
            'image' => 'required|image|mimes:jpeg,gif,png',
        ]);

        $path = Storage::disk('public')->putFile('photos', $request->file('image'));

        $data = array_merge($data, [
            'user_id' => $request->user()->id,
            'image' => asset("storage/{$path}"),
            'image_path' => storage_path('app/public') . "/{$path}",
        ]);

        $photo = Photo::create($data);

        return response()->json([
            'status' => 'success',
            'data' => $photo->load(['user', 'comments'])
        ]);
    }
}
