require 'rails_helper'

RSpec.describe "いいね", type: :system do
  let(:user) { create(:user) }
  let!(:sauna) { create(:sauna) }
  let!(:post) { create(:post) }
  let!(:like) { create(:like, user: user) }
  include LoginMacros

  it 'いいねができること' do
    login(user)
    visit '/posts'
    find("a[href='#{post_path(post)}']").click
    find("#like-button-for-post-#{post.id}").click
    expect(current_path).to eq("/posts/#{post.id}")
    expect(page).to have_selector("#unlike-button-for-post-#{post.id}")
  end

end
