require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let(:user) { create(:user) }
  let(:sauna) { create(:sauna) }
  let(:post1) { create(:post, content: 'ポスト１') }
  let(:post2) { create(:post, content: 'ポスト２') }
  let(:post3) { create(:post, content: 'ポスト３') }
  let(:post4) { create(:post, content: 'ポスト４') }
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
    end
  end
end
