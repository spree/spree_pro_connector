require 'spec_helper'

module Spree
  describe Api::IntegratorController do
    render_views

    before do
      stub_authentication!
    end

    it 'gets everything changed since' do
      order = create(:order, :updated_at => 2.days.ago, :completed_at => 2.days.ago)
      api_get :index, since: 3.days.ago.utc.to_s, page: 1, per_page: 3
      json_response['count'].should eq 1
      json_response['orders'].first['number'].should eq order.number
    end

    it 'adds stock for a variant' do
      variant = create(:variant, :count_on_hand => 10)
      api_post :add_stock, :variant_id => variant.id, :quantity => 10
      variant.reload
      variant.count_on_hand.should eq 20

      json_response['count_on_hand'].should eq 20
    end
  end
end
