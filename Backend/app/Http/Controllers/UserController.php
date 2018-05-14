<?php

namespace App\Http\Controllers;

use App\User;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function index()
    {
        $users = [];

        User::with('followers')->otherUsers()->get()->each(function ($user, $index) use (&$users) {
            $users[$index] = $user;
            $users[$index]['follows'] = auth()->user()->isFollowing($user);
        });

        return response()->json(['data' => $users]);
    }

    public function create(Request $request)
    {
        $credentials = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:6',
        ]);

        $credentials['password'] = Hash::make($credentials['password']);

        $user = User::create($credentials);

        $token = $user->createToken(config('app.name'));

        $data = ['user' => $user, 'access_token' => $token->accessToken];

        return response()->json(['data' => $data, 'status' => 'success']);
    }
}
