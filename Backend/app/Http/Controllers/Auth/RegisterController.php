<?php

namespace App\Http\Controllers\Auth;

use App\User;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Hash;

class RegisterController extends Controller
{
    public function register(Request $request)
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
