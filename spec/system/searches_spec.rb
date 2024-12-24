require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let(:user) { create(:user) }
  let(:sauna) { create(:sauna) }
  let(:post1) { create(:post, body: 'ポスト１') }
  let(:post2) { create(:post, body: 'ポスト２') }
  let(:post3) { create(:post, body: 'ポスト３') }
  let(:post4) { create(:post, body: 'ポスト４') }
  include LoginMacros
end
