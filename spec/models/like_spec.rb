require 'rails_helper'

RSpec.describe Like, type: :model do
  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      like = build(:like)
      expect(like).to be_valid
    end
  end
end
