<?php

use Illuminate\Database\Seeder;
use App\User;
use App\UserFollow;

class UserFollowsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $user1 = User::whereEmail('ysiwoku@gmail.com')->firstOrFail();
        $user2 = User::whereEmail('neo@creativitykills.co')->firstOrFail();

        UserFollow::create(['follower_id' => $user1->id, 'following_id' => $user2->id]);
        UserFollow::create(['follower_id' => $user2->id, 'following_id' => $user1->id]);
    }
}
