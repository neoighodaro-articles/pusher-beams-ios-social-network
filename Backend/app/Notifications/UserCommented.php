<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Neo\PusherBeams\PusherBeams;
use Neo\PusherBeams\PusherMessage;
use App\User;
use App\PhotoComment;
use App\Photo;

class UserCommented extends Notification
{
    use Queueable;

    public $user;

    public $comment;

    public $photo;

    public function __construct(User $user, Photo $photo, PhotoComment $comment)
    {
        $this->user = $user;
        $this->photo = $photo;
        $this->comment = $comment;
    }

    public function via($notifiable)
    {
        return [PusherBeams::class];
    }

    public function toPushNotification($notifiable)
    {
        return PusherMessage::create()
            ->iOS()
            ->sound('success')
            ->title('New Comment')
            ->body("{$this->user->name} commented on your photo: {$this->comment->comment}")
            ->setOption('apns.aps.mutable-content', 1)
            ->setOption('apns.data.attachment-url', $this->photo->image);
    }

    public function pushNotificationInterest()
    {
        $id = $this->photo->id;

        $audience = strtolower($this->user->settings->notification_comments);

        return "photo_{$id}-comment_{$audience}";
    }
}
