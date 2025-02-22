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

  it 'プロフィールの編集ができること' do
    visit '/profile'
    find("a[href='#{edit_profile_path}']").click
    Capybara.assert_current_path("/profile/edit", ignore_query: true)
    expect(current_path).to eq('/profile/edit'), 'プロフィール編集ページに遷移していません'
    fill_in 'ニックネーム', with: '編集後ニックネーム'
    fill_in 'メールアドレス', with: 'edit@sample.com'
    file_path = Rails.root.join('spec', 'fixtures', 'sample_avatar.png')
    attach_file('アバター', file_path)
    click_button '更新'
    Capybara.assert_current_path("/profile", ignore_query: true)
    expect(current_path).to eq('/profile'), 'マイページに遷移していません'
    expect(page).to have_content('ユーザーを更新しました'), 'フラッシュメッセージ「ユーザーを更新しました」が表示されていません'
    expect(page).to have_content('編集後ニックネーム'), '更新後のニックネームが表示されていません'
    # 画像はアップロード後.webpに変換
    expect(page).to have_selector("img[src$='sample_avatar.webp']"), '更新後のアバターが表示されていません'
  end

  it 'プロフィールの編集に失敗すること' do
    visit '/profile'
    find("a[href='#{edit_profile_path}']").click
    Capybara.assert_current_path("/profile/edit", ignore_query: true)
    expect(current_path).to eq('/profile/edit'), 'プロフィール編集ページに遷移していません'
    fill_in 'ニックネーム', with: ''
    fill_in 'メールアドレス', with: ''
    click_button '更新'
    expect(page).to have_content('ユーザーを更新できませんでした'), 'フラッシュメッセージ「ユーザーを更新できませんでした」が表示されていません'
    expect(page).to have_content('ニックネームを入力してください'), 'エラーメッセージ「ニックネームを入力してください」が表示されていません'
    expect(page).to have_content('メールアドレスを入力してください'), 'エラーメッセージ「メールアドレスを入力してください」が表示されていません'
  end
end
