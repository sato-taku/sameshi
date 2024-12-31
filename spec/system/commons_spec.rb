require 'rails_helper'

RSpec.describe "共通系", type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
    describe 'ヘッダー' do
      it '通知が表示されていないこと' do
        expect(page).not_to have_selector('.dropdown.fixed.top-4.left-2.md\:left-4.z-50')
      end
    end
  end
end
