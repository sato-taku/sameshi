require 'rails_helper'

RSpec.describe "パスワードリセット", type: :system do
  let(:user) { create(:user) }

  describe 'タイトル' do
    describe 'パスワードリセット申請ページ' do
      it '正しいタイトルが表示されていること' do
        visit new_password_reset_path
        expect(page).to have_title('パスワードリセット申請')
      end
    end
  end
end
