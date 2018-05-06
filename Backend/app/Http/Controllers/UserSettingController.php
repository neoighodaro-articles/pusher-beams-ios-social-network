<?php

namespace App\Http\Controllers;

use App\UserSetting;
use Illuminate\Http\Request;

class UserSettingController extends Controller
{
    public function index()
    {
        return response()->json(UserSetting::forCurrentUser()->first());
    }

    public function update(Request $request)
    {
        $settings = $request->validate([
            'notification_comments' => 'in:Off,Following,Everyone',
        ]);

        $updated = auth()->user()->settings()->update($settings);

        return response()->json(['status' => $updated ? 'success' : 'error']);
    }
}
