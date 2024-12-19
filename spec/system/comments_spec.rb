require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:me) { create(:user) }
  let(:post) { create(:post) }
  let!(:comment_by_me) { create(:comment, user: me, post: post) }
  let!(:comment_by_others) { create(:comment, post: post) }
  include LoginMacros
end
