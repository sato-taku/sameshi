require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let(:user) { create(:user) }
  let(:sauna) { create(:sauna) }
  let!(:post1) { create(:post, content: 'ポスト１') }
  let!(:post2) { create(:post, content: 'ポスト２') }
  let!(:post3) { create(:post, content: 'ポスト３', meal_genre: 'ラーメン') }
  let!(:post4) { create(:post, content: 'ポスト４') }
  include LoginMacros

  describe '投稿一覧画面での検索' do
    before do
      login(user)
      post1
      post2
      visit '/posts'
    end
    context '検索条件に該当する投稿がある場合' do
      describe 'フリーワードでの検索機能の検証' do
        it '該当する投稿のみ表示されること' do
          fill_in 'フリーワード', with: '１'
          find("button[type='submit']").click
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts')
          expect(page).to have_content(post1.user.nickname)
        end
      end

      describe 'サウナ施設での検索機能の検証' do
        it '該当する投稿のみ表示されること' do
          fill_in 'サウナ施設', with: 'サウナ'
          find("button[type='submit']").click
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts')
          expect(page).to have_content(post1.user.nickname)
          expect(page).to have_content(post2.user.nickname)
          # expect(page).to have_content(post3.user.nickname)
          # expect(page).to have_content(post4.user.nickname)
        end
      end

      describe 'ジャンルでの検索機能の検証' do
        it '該当する投稿のみ表示されること' do
          select 'ラーメン', from: 'post_meal_genre_eq'
          find("button[type='submit']").click
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts')
          expect(page).to have_content(post3.user.nickname)
        end
      end
    end

    context '検索条件に該当する投稿がない場合' do
      it '1件もない旨のメッセージが表示されること' do
        fill_in 'フリーワード', with: '５'
        find("button[type='submit']").click
        Capybara.assert_current_path("/posts", ignore_query: true)
        expect(current_path).to eq('/posts')
        expect(page).to have_content('投稿がありません')
      end
    end
  end
end
