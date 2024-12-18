class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true, length: { maximum: 150 }

  after_create_commit :create_comment_notification

  private

  def create_comment_notification
    return if self.user_id == self.post.user_id

      Notification.create(
        sender_id: self.user_id,
        recipient_id: self.post.user_id,
        notifiable: self
      )
  end
end
