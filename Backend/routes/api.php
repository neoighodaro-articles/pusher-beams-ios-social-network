<?php

Route::post('/register', 'UserController@create');

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
