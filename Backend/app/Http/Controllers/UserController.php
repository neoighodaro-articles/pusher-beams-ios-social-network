<?php

namespace App\Http\Controllers;

use App\User;

class UserController extends Controller
{
    public function index()
    {
        $users = [];

        $me = auth()->user();

        User::with('followers')->otherUsers()->get()->each(function ($user, $index) use (&$users) {
            $following = $user->followers->where('follower_id', auth()->user()->id)->count();
            $users[$index] = $user;
            $users[$index]['follows'] = (bool) $following;
        });

        return response()->json(['data' => $users]);
    }
}
