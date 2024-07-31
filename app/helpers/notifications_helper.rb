module NotificationsHelper
  def generate_notification_message(notification)
    return unless notification

    case notification.notifiable_type
    when 'Comment'
      "#{notification.sender.nickname} が #{notifiable_name(notification)} にコメントしました".html_safe
    When 'Like'
      "#{notification.sender.nickname} が #{notifiable_name(notification)} にいいね！しました".html_safe
    else
      '新着通知がありました'
    end
  end

  def generate_post_link(post)
    link_to post.sauna.name, post_path(post), class: "link link-primary", data: { turbo: false }
  end
end
