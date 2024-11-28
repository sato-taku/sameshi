require 'rails_helper'

RSpec.describe '投稿', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:post) { create(:post) }

  describe '投稿のCRUD' do
    describe '投稿の一覧' do
      context '投稿が一件もない場合' do
        it '何もない旨のメッセージが表示されること' do
          visit '/posts'
          expect(page).to have_content('投稿がありません'), '投稿が一件もない場合「投稿がありません」というメッセージが表示されていません'
        end
      end

      context '投稿がある場合' do
        it '投稿の一覧が表示されること' do
          post
          visit '/posts'
          expect(page).to have_content(post.user.nickname), '投稿一覧画面に投稿者のニックネームが表示されていません'
          # expect(page).to have_content(post.post_image), '投稿一覧画面に投稿画像が表示されていません'
          # expect(page).to have_content(post.created_at), '投稿一覧画面に投稿時間が表示されていません'
        end
      end

      context '6件以下の場合' do
        let!(:posts) { create_list(:post, 6) }
        it 'ページングが表示されないこと' do
          visit '/posts'
          expect(page).not_to have_selector('.pagination')
        end
      end

      context '6件以上の場合' do
        let!(:posts) { create_list(:post, 7) }
        it 'ページングが表示されること' do
          visit '/posts'
          expect(page).to have_selector('.pagination')
        end
      end
    end

    describe '投稿の詳細' do
      context 'ログインしていない場合' do
        before do
          post
        end
        it '投稿の詳細が表示されること' do
          visit '/posts'
          find("a[href='#{post_path(post)}']").click
          Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
          expect(current_path).to eq("/posts/#{post.id}"), '投稿のカードリンクから投稿詳細画面へ遷移できません'
        end
      end
    end
  end
end
