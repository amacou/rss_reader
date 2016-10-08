require 'spec_helper'

describe "Folders", type: :request do
  let(:user) { create(:user) }

  before do
    login(user)
  end

  describe "GET /folders" do
    it "works! (now write some real specs)" do
      get folders_path
      response.status.should be(200)
    end
  end
end
