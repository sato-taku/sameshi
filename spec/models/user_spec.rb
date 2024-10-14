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

  it '必須項目を入力する必要があること' do
    user = build(:user)
    user.nickname = nil
    user.prefecture_id = nil
    user.age_group = nil
    user.email = nil
    user.password = nil
    user.password_confirmation = nil
    user.valid?
    expect(user.errors[:nickname]).to include('を入力してください')
    expect(user.errors[:prefecture_id]).to include('を入力してください')
    expect(user.errors[:age_group]).to include('は一覧にありません')
    expect(user.errors[:email]).to include('を入力してください')
    expect(user.errors[:password]).to include('は4文字以上で入力してください')
    expect(user.errors[:password_confirmation]).to include('を入力してください')
  end

  it 'ニックネームは20文字以下であること' do
    user = build(:user)
    user.nickname = 'n' * 21
    user.valid?
    expect(user.errors[:nickname]).to include('は20文字以内で入力してください')
  end

  it '確認事項をチェックしていること' do
    user = build(:user)
    user.agreement = nil
    user.valid?
    expect(user.errors[:agreement]).to include('を受諾してください')
  end
end
