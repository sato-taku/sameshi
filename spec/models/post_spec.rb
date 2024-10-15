require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'すべてのフィールドが有効な場合' do
    it '有効であること' do
      post = create(:post)
      expect(post).to be_valid
    end
  end

  context 'サ飯ジャンルが存在しない場合' do
    it '無効であること' do
      post = build(:post, meal_genre: nil)
      expect(post).to be_invalid
      expect(post.errors[:meal_genre]).to include('を入力してください')
    end
  end

  context '内容が存在しない場合' do
    it '無効であること' do
      post = build(:post, content: nil)
      expect(post).to be_invalid
      expect(post.errors[:content]).to include('を入力してください')
    end
  end

  context '都道府県が存在しない場合' do
    it '無効であること' do
      post = build(:post, prefecture: nil)
      expect(post).to be_invalid
      expect(post.errors[:prefecture]).to include('を入力してください')
    end
  end

  context 'サウナ施設が存在しない場合' do
    it '無効であること' do
      post = build(:post, sauna: nil)
      expect(post).to be_invalid
      expect(post.errors[:sauna]).to include('を入力してください')
    end
  end
end
