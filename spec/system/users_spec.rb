require 'rails_helper'

RSpec.describe "ユーザー登録", type: :system do
  before do
    Prefecture.create(name: '新潟県')
  end

  it '正しいタイトルが表示されていること' do
    visit '/users/new'
    expect(page).to have_title("ユーザー登録 | サ飯の時間"), 'ユーザー登録ページのタイトルに「ユーザー登録 | サ飯の時間」が含まれていません。'
  end

  context '入力情報正常' do
    it 'ユーザーが新規作成できること' do
      visit 'users/new'
      expect {
        fill_in 'ニックネーム', with: 'サウナ太郎'
        select '新潟県', from: '都道府県'
        select '30代', from: '年代'
        fill_in 'メールアドレス', with: 'sauna@sample.com'
        fill_in 'パスワード', with: 'pass'
        fill_in 'パスワード（確認用）', with: 'pass'
        check 'agreement'
        click_button '登録'
        Capybara.assert_current_path("/", ignore_query: true)
      }.to change { User.count }.by(1)
      expect(page).to have_content('ユーザー登録が完了しました'), 'フラッシュメッセージ「ユーザー登録が完了しました」が表示されていません'
    end
  end
end
