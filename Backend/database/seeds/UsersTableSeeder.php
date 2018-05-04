<?php

use App\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        User::create([
            'name' => 'Neo Ighodaro',
            'email' => 'neo@creativitykills.co',
            'password' => Hash::make('secret'),
        ]);

        User::create([
            'name' => 'Yewande Siwoku',
            'email' => 'ysiwoku@gmail.com',
            'password' => Hash::make('secret'),
        ]);
    }
}
