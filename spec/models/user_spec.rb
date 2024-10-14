require 'rails_helper'

RSpec.describe User, type: :model do
  it 'ニックネーム、メール、年代、都道府県があり、パスワードは4文字以上であれば有効であること' do
    user = create(:user)
    expect(user).to be_valid
  end

  it 'メールはユニークであること' do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include('はすでに存在します')
  end
end
