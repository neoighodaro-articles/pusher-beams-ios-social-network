<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Notification;
use Neo\PusherBeams\PusherBeams;
use Neo\PusherBeams\PusherMessage;
use Illuminate\Contracts\Queue\ShouldQueue;
use App\User;
use App\PhotoComment;
use App\Photo;

class UserCommented extends Notification implements ShouldQueue
{
    use Queueable;

    /**
     * @var \App\User
     */
    public $user;

    /**
     * @var \App\PhotoComment
     */
    public $comment;

    /**
     * @var \App\Photo
     */
    public $photo;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(User $user, Photo $photo, PhotoComment $comment)
    {
        $this->user = $user;
        $this->photo = $photo;
        $this->comment = $comment;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return [PusherBeams::class];
    }

    /**
     * To push notificattion
     *
     * @param mixed $notifiable
     * @return array
     */
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

    /**
     * Push notification interest to publish to
     *
     * @return array|string
     */
    public function pushNotificationInterest()
    {
        $id = $this->photo->id;
        $audience = strtolower($this->user->settings->notification_comments);

        return "photo_{$id}-comment_{$audience}";
    }
}
