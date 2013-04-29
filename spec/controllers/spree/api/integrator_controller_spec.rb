require 'spec_helper'

module Spree
  describe Api::IntegratorController do
    render_views

    before do
      stub_authentication!
    end

    it 'gets everything changed since' do
      order = create(:order,
             :updated_at => 2.days.ago,
             :completed_at => 2.days.ago)

      api_get :index, since: 3.days.ago.utc.to_s,
               order_page: 1,
               order_per_page: 1


      json_response['orders']['count'].should eq 1
      json_response['orders']['current_page'].should eq 1

      json_response['orders']['page'].first['number'].should eq order.number
      json_response['orders']['page'].first.should have_key('ship_address')
      json_response['orders']['page'].first.should have_key('bill_address')
      json_response['orders']['page'].first.should have_key('payments')
      json_response['orders']['page'].first.should have_key('credit_cards')
    end
  end
end
