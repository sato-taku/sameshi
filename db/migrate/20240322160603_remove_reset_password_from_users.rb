class RemoveResetPasswordFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_token_expires_at
    remove_column :users, :reset_password_email_sent_at
    remove_column :users, :access_count_to_reset_password_page
  end
end
