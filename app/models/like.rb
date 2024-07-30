class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }

  after_create_commit :create_like_notification

  private

  def create_like_notification
    return if self.user_id == self.likeable.user_id
    if self.likeable
      Notification.create(
        sender_id: self.user_id,
        recipient_id: self.likeable.user_id,
        notifiable: self
      )
    end
  end
end
