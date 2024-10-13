require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ニックネーム、メール、年代、都道府県があり、パスワードは4文字以上であれば有効であること' do
    user = create(:user)
    expect(user).to be_valid
  end
end
