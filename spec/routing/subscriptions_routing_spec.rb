require "spec_helper"
describe SubscriptionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/subscriptions").to route_to("subscriptions#index")
    end

    it "routes to #new" do
      expect(:get => "/subscriptions/new").to route_to("subscriptions#new")
    end

    it "routes to #edit" do
      expect(:get => "/subscriptions/1/edit").to route_to("subscriptions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/subscriptions").to route_to("subscriptions#create")
    end

    xit "routes to #update" do
      # TODO waiting for replace 'change folder' to 'udpate'
      expect(:put => "/subscriptions/1").to route_to("subscriptions#update", :id => "1")
    end

    it "routes to #change_folder" do
      # TODO waiting for replace 'change folder' to 'udpate'
      expect(:post => "/subscriptions/change_folder").to route_to("subscriptions#change_folder")
    end

    it "routes to #subscribe" do
      expect(:post => "/subscriptions/subscribe").to route_to("subscriptions#subscribe")
    end

    it "routes to #unsubscribe" do
      expect(:post => "/subscriptions/unsubscribe").to route_to("subscriptions#unsubscribe")
    end

    it "routes to #destroy" do
      expect(:delete => "/subscriptions/1").to route_to("subscriptions#destroy", :id => "1")
    end
  end
end
