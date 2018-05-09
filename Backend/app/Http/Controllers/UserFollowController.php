<?php

namespace App\Http\Controllers;

use App\User;
use App\UserFollow;
use Illuminate\Http\Request;

class UserFollowController extends Controller
{
    public function follow(Request $request)
    {
        $user = User::findOrFail($data['following_id']);

        if ($request->user()->isFollowing($user) == false) {
            $request->user()->following()->save(new UserFollow($data));
        }

        return response()->json(['status' => 'success']);
    }

    public function unfollow(Request $request)
    {
        $user = User::findOrFail($data['following_id']);

        if ($request->user()->isFollowing($user)) {
            $request->user()->following()->whereFollowingId($user->id)->delete();
        }

        return response()->json(['status' => 'success']);
    }
}
