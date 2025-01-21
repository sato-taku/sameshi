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

    describe 'パスワードリセットページ' do
      it '正しいタイトルが表示されていること' do
        user.generate_reset_password_token!
        visit edit_password_reset_path(user.reset_password_token)
        expect(page).to have_title('パスワードリセット')
      end
    end
  end

  it 'パスワード変更ができる' do
    visit new_password_reset_path
    fill_in 'メールアドレス', with: user.email
    click_button '送信'
    expect(page).to have_content('パスワードリセット手順を送信しました')
    visit edit_password_reset_path(user.reload.reset_password_token)
    fill_in 'パスワード', with: '12345678'
    fill_in 'パスワード（確認用）', with: '12345678'
    click_button '更新'
    Capybara.assert_current_path("/login", ignore_query: true)
    expect(current_path).to eq('/login')
    expect(page).to have_content('パスワードを変更しました')
  end
end
