require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:me) { create(:user) }
  let(:post) { create(:post) }
  let(:sauna) { create(:sauna) }
  let!(:comment_by_me) { create(:comment, user: me, post: post) }
  let!(:comment_by_others) { create(:comment, post: post) }
  include LoginMacros

  describe 'コメントのCRUD' do
    before do
      login(me)
      visit '/posts'
      find("a[href='#{post_path(post)}']").click
    end

    describe 'コメントの一覧' do
      it 'コメントの一覧が表示されること' do
        expect(page).to have_content(comment_by_me.body)
        expect(page).to have_content(comment_by_me.user.nickname)
      end
    end

    describe 'コメントの作成' do
      it 'コメントを作成できること' do
        fill_in 'コメント', with: '新規コメント'
        find("button[type='submit']").click
        sleep(0.5)
        comment = Comment.last
        within "#comment-#{comment.id}" do
          expect(page).to have_content(me.nickname)
          expect(page).to have_content('新規コメント')
        end
      end

      describe 'コメントの削除' do
        context '自分のコメントの場合' do
          it 'コメントを削除できること' do
            within("#comment-#{comment_by_me.id}") do
              page.accept_confirm { find('.delete-comment-link').click }
            end
            expect(page).not_to have_content(comment_by_me.body)
          end
        end

        context '他人のコメントの場合' do
          it '削除ボタンが表示されないこと' do
            within("#comment-#{comment_by_others.id}") do
              expect(page).not_to have_selector('.delete-comment-button')
            end
          end
        end
      end
    end
  end
end
