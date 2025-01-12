require 'rails_helper'

RSpec.describe "共通系", type: :system do
  let(:user) { create(:user) }
  include LoginMacros

  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it '通知が表示されていないこと' do
        expect(page).not_to have_selector('.dropdown.fixed.top-4.left-2.md\:left-4.z-50')
      end
    end
    
    describe 'ハンバーガーメニュー' do
      it 'ログインボタンが表示されていること' do
        find('.drawer-button.btn.btn-ghost').click
        expect(page).to have_content('ログイン')
      end

      it '新規登録ボタンが表示されていること' do
        find('.drawer-button.btn.btn-ghost').click
        expect(page).to have_content('新規登録')
      end
    end

    describe 'フッター' do
      it '新規投稿ページに遷移せずログインページに遷移すること' do
        find('a[data-tip="新規投稿"]').click
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq('/login')
      end

      it 'マイページに遷移せずログインページに遷移すること' do
        find('a[data-tip="マイページ"]').click
        expect(page).to have_content('ログインしてください')
        expect(current_path).to eq('/login')
      end
    end

    describe 'タイトル' do
      it 'タイトルが正しく表示されていること' do
        expect(page).to have_title('サ飯の時間')
      end
    end
  end

  context 'ログイン後' do
    before do
      login(user)
    end
    describe 'ヘッダー' do
      it '通知が表示されていること' do
        expect(page).to have_selector('.dropdown.fixed.top-4.left-2.md\:left-4.z-50')
      end

      it 'ロゴを押下するとトップページに遷移すること' do
        visit posts_path
        find('#header-logo').click
        Capybara.assert_current_path("/", ignore_query: true)
        expect(current_path).to eq('/')
      end
    end

    describe 'ハンバーガーメニュー' do
      it 'マイページボタンが表示されていること' do
        expect(page).to have_content('マイページ')
      end

      it 'ログアウトボタンが表示されていること' do
        expect(page).to have_content('ログアウト')
      end
    end

    describe 'フッター' do
      it '新規投稿ページに遷移すること' do
        find('a[data-tip="新規投稿"]').click
        Capybara.assert_current_path("/posts/new", ignore_query: true)
        expect(current_path).to eq('/posts/new')
      end

      it 'マイページに遷移すること' do
        find('a[data-tip="マイページ"]').click
        Capybara.assert_current_path("/profile", ignore_query: true)
        expect(current_path).to eq('/profile')
      end
    end

    describe 'タイトル' do
      it 'タイトルが正しく表示されていること' do
        expect(page).to have_title('サ飯の時間')
      end
    end
  end
end
