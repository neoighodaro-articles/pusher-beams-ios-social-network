<?php

namespace App\Http\Controllers;

use App\User;
use App\UserFollow;
use Illuminate\Http\Request;

class UserFollowController extends Controller
{
    public function follow(Request $request)
    {
        $user = User::findOrFail($request->get('following_id'));

        if ($request->user()->isFollowing($user) == false) {
            $request->user()->following()->save(new UserFollow($request->only('following_id')));
        }

        return response()->json(['status' => 'success']);
    }

    public function unfollow(Request $request)
    {
        $user = User::findOrFail($request->get('following_id'));

        $request->user()->following()->whereFollowingId($user->id)->delete();

        return response()->json(['status' => 'success']);
    }
}
