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
  end
end
