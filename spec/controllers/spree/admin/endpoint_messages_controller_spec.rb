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

      context "search" do
        it "filter by message" do
          em1, em2 = create(:endpoint_message, payload: %Q{{"message":"test:search"}}, uri: "spreecommerce.com"), create(:endpoint_message)
          spree_get :index, q: { message_eq: "test:search" }
          expect(assigns(:endpoint_messages)).to match_array([em1])
        end

        it "filter by uri" do
          em1, em2 = create(:endpoint_message, payload: %Q{{"message":"test:search"}}, uri: "spreecommerce.com"), create(:endpoint_message)
          spree_get :index, q: { uri_cont: "spree" }
          expect(assigns(:endpoint_messages)).to match_array([em1])
        end
      end
    end

    describe "#create" do
      before do
        Spree::Admin::ApiRequest.stub post: {}
      end

      it "creates a new message" do
        expect {
          spree_post :create, endpoint_message: attributes_for(:endpoint_message),
          new_parameter_pairs: { "1" => { "name" => "super.token", "value" => "ABC" } }
        }.to change(Spree::EndpointMessage, :count).by 1

        expect(response).to redirect_to spree.edit_admin_endpoint_message_path(Spree::EndpointMessage.last)
      end

      context "parameters is empty" do
        it "creates a new message" do
          expect {
            spree_post :create, endpoint_message: attributes_for(:endpoint_message), new_parameter_pairs: nil
          }.to change(Spree::EndpointMessage, :count).by 1
        end
      end
    end

    describe "#clone" do
      before do
        Spree::Admin::ApiRequest.stub post: {}
      end

      it "duplicates a new message" do
        original = create(:endpoint_message)
        expect {
          spree_post :clone, id: original.id
        }.to change(Spree::EndpointMessage, :count).by 1
      end
    end
  end
end

