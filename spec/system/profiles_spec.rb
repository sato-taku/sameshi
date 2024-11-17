require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  let(:user) { create(:user) }
  before do
    login(user)
  end

  pending "add some scenarios (or delete) #{__FILE__}"
end
