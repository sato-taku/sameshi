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
    find("#like-button-for-post-#{post.id}").click
    expect(current_path).to eq('/posts')
    expect(page).to have_selector("#unlike-button-for-post-#{post.id}")
  end

  it 'いいねを外せること' do
    login(user)
    visit '/posts'
    find("#unlike-button-for-post-#{like.post.id}").click
    expect(current_path).to eq('/posts')
    expect(page).to have_selector("#like-button-for-post-#{post.id}")
  end
end
