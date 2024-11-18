require 'rails_helper'

RSpec.describe "プロフィール", type: :system do
  let(:user) { create(:user) }
  include LoginMacros
  before do
    login(user)
  end

  it 'マイページ詳細が見られること' do
    visit '/profile'
    Capybara.assert_current_path("/profile", ignore_query: true)
    expect(current_path).to eq('/profile'), 'マイページに遷移していません'
    expect(page).to have_content(user.nickname), 'ニックネームが表示されていません'
  end
end
