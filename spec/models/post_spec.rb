require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'すべてのフィールドが有効な場合' do
    it '有効であること' do
      post = create(:post)
      expect(post).to be_valid
    end
  end
end
