<?php


/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/register', 'Auth\RegisterController@register');

Route::group(['middleware' => 'auth:api'], function () {
    Route::get('/users/settings', 'UserSettingController@index');
    Route::put('/users/settings', 'UserSettingController@update');
    Route::post('/users/follow', 'UserFollowController@follow');
    Route::post('/users/unfollow', 'UserFollowController@unfollow');
    Route::get('/users', 'UserController@index');
    Route::get('/photos/{photo}/comments', 'PhotoCommentController@index');
    Route::post('/photos/{photo}/comments', 'PhotoCommentController@store');
    Route::resource('/photos', 'PhotoController')->only(['store', 'index']);
});
