require 'spec_helper'

module Spree::Admin
  describe EndpointMessagesController do
    render_views
    stub_authorization!

    before do
      stub_authentication!
    end

    describe "#index" do
      it "returns endpoint messages" do
        em1, em2 = create(:endpoint_message), create(:endpoint_message)
        spree_get :index
        expect(assigns(:endpoint_messages)).to match_array([em1, em2])
      end

      it "searches by query" do
        em1, em2 = create(:endpoint_message, payload: %Q{{"message":"test:search"}}, uri: "spreecommerce.com"), create(:endpoint_message)
        spree_get :index, q: { message_eq: "test:search", uri_cont: "spree" }
        expect(assigns(:endpoint_messages)).to match_array([em1])
      end
    end
  end
end

