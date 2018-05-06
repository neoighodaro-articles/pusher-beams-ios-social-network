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
            $users[$index] = $user;
            $users[$index]['follows'] = $user->isFollowing(auth()->user());
        });

        return response()->json(['data' => $users]);
    }
}
