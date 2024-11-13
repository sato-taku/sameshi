require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:general_user) { create(:user, :general) }
  let(:admin_user) { create(:user, :admin) }
  include LoginMacros

  describe '通常画面' do
    describe 'ログイン' do
      it '正しいタイトルが表示されていること' do
        visit '/login'
        expect(page).to have_title("ログイン | サ飯の時間"), 'タイトルに「ログイン | サ飯の時間」が含まれていません。'
      end

      context '認証情報が正しい場合' do
        it 'ログインできること' do
          visit '/login'
          fill_in 'メールアドレス', with: general_user.email
          fill_in 'パスワード', with: '12345678'
          click_button 'ログイン'
          Capybara.assert_current_path("/", ignore_query: true)
          expect(current_path).to eq '/'
          expect(page).to have_content('ログインしました'), 'フラッシュメッセージ「ログインしました」が表示されていません'
        end
      end

      context 'PWに誤りがある場合' do
        it 'ログインできないこと' do
          visit '/login'
          fill_in 'メールアドレス', with: general_user.email
          fill_in 'パスワード', with: '1234'
          click_button 'ログイン'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログイン失敗時にログイン画面に戻ってきていません'
          expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
        end
      end
    end

    describe 'ログアウト' do
      before do
        login(general_user)
      end
      it 'ログアウトできること' do
        visit '/profile'
        within('.card.w-full.shadow-xl.mx-auto.mb-8.max-w-sm.md\\:max-w-4xl') do
          click_on 'ログアウト'
        end        
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq('/')
        expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
      end
    end
  end
  describe '管理画面' do
    describe 'ログイン' do
      describe 'ログイン失敗' do
        context '管理者以外の場合' do
          it 'トップページにリダイレクトされること' do
            visit '/admin'
            fill_in 'メールアドレス', with: general_user.email
            fill_in 'パスワード', with: '12345678'
            click_button 'ログイン'
            Capybara.assert_current_path("/", ignore_query: true)
            expect(current_path).to eq '/'
          end
        end
      end
    end
  end
end
