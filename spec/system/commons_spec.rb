require 'rails_helper'

RSpec.describe "共通系", type: :system do
  context 'ログイン前' do
    before do
      visit root_path
    end
end
