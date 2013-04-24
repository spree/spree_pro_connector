require 'spec_helper'

module Spree
  describe Api::IntegratorController do
    render_views

    before do
      stub_authentication!
    end

    it 'gets everything changed since' do
      order = create(:order, :updated_at => 2.days.ago, :completed_at => 2.days.ago)
      api_get :index, since: 3.days.ago.utc.to_s
      json_response['count'].should eq 1
      json_response['orders'].first['number'].should eq order.number
    end
  end
end
