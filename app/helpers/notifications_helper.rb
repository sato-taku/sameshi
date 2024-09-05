module NotificationsHelper
  def generate_notification_message(notification)
    return unless notification

    case notification.notifiable_type
    when 'Comment'
      "#{notification.sender.nickname} が 『 #{generate_post_link(notification.notifiable.post)} 』 にコメントしました".html_safe
		when 'Like'
      "#{notification.sender.nickname} が 『 #{generate_post_link(notification.notifiable.post)} 』 にいいね！しました".html_safe
    else
      '新着通知がありました'
    end
  end

  def generate_post_link(post)
    link_to post.sauna.name, post_path(post), class: "link hover:link-info link-bold", data: { turbo: false }
  end
end
