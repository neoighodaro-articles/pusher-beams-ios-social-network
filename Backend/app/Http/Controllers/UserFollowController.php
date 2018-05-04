<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use App\UserFollow;
use Illuminate\Support\Facades\Auth;

class UserFollowController extends Controller
{
    public function follow(Request $request)
    {
        $data = $request->validate([
            'following_id' => [
                'required',
                'exists:users,id',
                'not_in:' . Auth::user()->id,
                Rule::unique('user_follows')->where(function ($query) {
                    $query->where('follower_id', Auth::user()->id);
                })
            ]
        ]);

        Auth::user()->following()->save(new UserFollow($data));

        return response()->json(['status' => 'success']);
    }

    public function unfollow(Request $request)
    {
        $data = $request->validate([
            'following_id' => [
                'required',
                'exists:users,id',
                'not_in:' . Auth::user()->id,
                Rule::exists('user_follows')->where(function ($query) {
                    $query->where('follower_id', Auth::user()->id);
                })
            ]
        ]);

        Auth::user()->following()->whereFollowingId($data['following_id'])->delete();

        return response()->json(['status' => 'success']);
    }
}
