require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  it '正しいタイトルが表示されていること' do
    visit '/users/new'
    expect(page).to have_title("ユーザー登録 | サ飯の時間"), 'ユーザー登録ページのタイトルに「ユーザー登録 | サ飯の時間」が含まれていません。'
  end
end
