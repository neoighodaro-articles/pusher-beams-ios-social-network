<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\User;
use App\UserSetting;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        User::created(function ($user) {
            $user->settings()->save(new UserSetting);
        });
    }

    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
