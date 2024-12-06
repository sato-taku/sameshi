require 'rails_helper'

RSpec.describe '投稿', type: :system do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:post) { create(:post) }
  let(:sauna) { create(:sauna) }
  include LoginMacros

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
        it '投稿の詳細と新規登録への誘導が表示されること' do
          visit '/posts'
          find("a[href='#{post_path(post)}']").click
          Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
          expect(current_path).to eq("/posts/#{post.id}"), '投稿のカードリンクから投稿詳細画面へ遷移できません'
          expect(page).to have_content(post.user.nickname)
          expect(page).to have_content(post.prefecture.name)
          expect(page).to have_content(post.sauna.name)
          expect(page).to have_content(post.meal_genre)
          expect(page).to have_content(post.content)
          expect(page).to have_content('あなたのお気に入りの「サ飯」も教えてね！')
          expect(page).to have_link('使ってみる！', href: '/users/new')
        end
      end

      context 'ログインしている場合' do
        before do 
          login(user)
          post
        end
        it '投稿の詳細とコメントフォームが表示されること' do
          visit '/posts'
          find("a[href='#{post_path(post)}']").click
          Capybara.assert_current_path("/posts/#{post.id}", ignore_query: true)
          expect(current_path).to eq("/posts/#{post.id}"), '投稿のカードリンクから投稿詳細画面へ遷移できません'
          expect(page).to have_content(post.user.nickname)
          expect(page).to have_content(post.prefecture.name)
          expect(page).to have_content(post.sauna.name)
          expect(page).to have_content(post.meal_genre)
          expect(page).to have_content(post.content)
          expect(page).to have_selector('div#like-button'), 'いいねボタンが表示されていません'
          expect(page).to have_selector('div#comment-form'), 'コメントフォームが表示されていません'
        end
      end
    end

    describe '投稿の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit '/posts/new'
          Capybara.assert_current_path("/login", ignore_query: true)
          expect(current_path).to eq('/login'), 'ログインしていない場合、新規投稿画面に遷移した際、ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end

      context 'ログインしている場合' do
        before do
          login(user)
        end
        it '正しいタイトルが表示されていること' do
          visit '/posts/new'
          Capybara.assert_current_path("/posts/new", ignore_query: true)
          expect(current_path).to eq("/posts/new"), '新規投稿ページに遷移していません'
          expect(page).to have_title("新規投稿 | サ飯の時間"), '新規投稿ページのタイトルに「新規投稿 | サ飯の時間」が含まれていません'
        end

        it '投稿が作成できること' do
          sauna
          visit '/posts/new'
          file_path = Rails.root.join('spec', 'fixtures', 'sample_post.png')
          attach_file('input', file_path)
          fill_in '内容', with: '内容本文'
          select '新潟県', from: '都道府県'
          select 'ラーメン', from: 'ジャンル'
          # サウナ入力欄オートコンプリート機能の選択ロジック
          find('input[data-autocomplete-target="input"]').set('サウナsample')
          expect(page).to have_selector('ul[data-autocomplete-target="results"]')
          find('ul[data-autocomplete-target="results"] li', text: 'サウナsample').click
          click_button '登録'
          Capybara.assert_current_path("/posts", ignore_query: true)
          expect(current_path).to eq('/posts'), '投稿一覧ページに遷移していません'
          expect(page).to have_content('投稿を作成しました'), 'フラッシュメッセージ「投稿を作成しました」が表示されていません'
          expect(page).to have_content(user.nickname)
          # 画像はアップロード後.webpに変換
          expect(page).to have_selector("img[src$='sample_post.webp']"), '投稿の画像が表示されていません'
        end

        it '投稿の作成に失敗すること' do
          sauna
          visit '/posts/new'
          file_path = Rails.root.join('spec', 'fixtures', 'sample_post.png')
          attach_file('input', file_path)
          select '新潟県', from: '都道府県'
          select 'ラーメン', from: 'ジャンル'
          find('input[data-autocomplete-target="input"]').set('サウナsample')
          expect(page).to have_selector('ul[data-autocomplete-target="results"]')
          find('ul[data-autocomplete-target="results"] li', text: 'サウナsample').click
          click_button '登録'
          expect(page).to have_content('投稿を作成できませんでした'), 'フラッシュメッセージ「投稿が作成できませんでした」が表示されていません'
          expect(page).to have_content('内容を入力してください'), 'エラーメッセージ「内容を入力してください」が表示されていません'
        end
      end
    end

    describe '投稿の更新' do
      before do
        post
      end
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit "/posts/#{post.id}/edit"
          expect(current_path).to eq('/login'), 'ログインページにリダイレクトされていません'
          expect(page).to have_content('ログインしてください'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
        end
      end
    end
  end
end
