require 'rails_helper'

RSpec.describe Comment, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  context '本文が存在しない場合' do
    it '無効であること' do
      comment = build(:comment, body: nil)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to include('を入力してください')
    end
  end

  context '本文が150文字以内の場合' do
    it '有効であること' do
      comment = build(:comment, body: 'n' * 150)
      expect(comment).to be_valid
    end
  end

  context '本文が150文字以上の場合' do
    it '無効であること' do
      comment = build(:comment, body: 'n' * 151)
      expect(comment).to be_invalid
      expect(comment.errors[:body]).to include('は150文字以内で入力してください')
    end
  end
end
