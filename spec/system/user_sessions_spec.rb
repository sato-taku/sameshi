require 'rails_helper'

RSpec.describe 'ログイン・ログアウト', type: :system do
  let(:general_user) { create(:user, :general) }
  let(:admin_user) { create(:user, :admin) }

  describe '通常画面' do
    describe 'ログイン' do
      it '正しいタイトルが表示されていること' do
        visit '/login'
        expect(page).to have_title("ログイン | サ飯の時間"), 'タイトルに「ログイン | サ飯の時間」が含まれていません。'
      end
    end
  end
end
