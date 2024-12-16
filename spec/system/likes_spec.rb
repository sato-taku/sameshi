require 'rails_helper'

RSpec.describe "いいね", type: :system do
  let(:user) { create(:user) }
  let!(:post) { create(:post) }
  let!(:like) { create(:like, user: user) }


end
