class ApplicationController < ActionController::Base
  before_action :require_login
  add_flash_types :success, :danger
  before_action :set_notification_object
  include NotificationsHelper

  private

  def not_authenticated
    redirect_to main_app.login_path, danger: "ログインしてください"
  end

  def set_notification_object
    @notifications = current_user.received_notifications.unread.order(created_at: :desc) if current_user
  end
end
