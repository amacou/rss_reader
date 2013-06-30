require 'spec_helper'

describe Feed do
  describe "pull" do
    before do
      @feed = FactoryGirl.create(:feed)
    end
    it "can do anything" do
      @feed.pull
    end
  end
end
