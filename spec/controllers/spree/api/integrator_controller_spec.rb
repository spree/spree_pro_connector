require 'spec_helper'

module Spree
  describe Api::IntegratorController do
    render_views

    before do
      stub_authentication!
    end

    it 'gets orders changed since' do
      order = create(:completed_order_with_totals)
      Order.update_all(:updated_at => 2.days.ago)

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

    it 'gets stock_transfers changed since' do
      source = create(:stock_location)
      destination = create(:stock_location_with_items, :name => 'DEST101')
      stock_transfer = StockTransfer.create do |transfer|
        transfer.source_location_id = source.id
        transfer.destination_location_id = destination.id
        transfer.reference_number = 'PO 666'
      end
      StockTransfer.update_all(:updated_at => 2.days.ago)

      StockMovement.create do |movement|
        movement.stock_item = source.stock_items.first
        movement.quantity = -1
        movement.originator = stock_transfer
      end

      StockMovement.create do |movement|
        movement.stock_item = destination.stock_items.first
        movement.quantity = 1
        movement.originator = stock_transfer
      end

      api_get :index, since: 3.days.ago.utc.to_s,
                      stock_transfers_page: 1,
                      stock_transfers_per_page: 1

      transfer = json_response['stock_transfers']['page'].first
      transfer['destination_location']['name'].should eq 'DEST101'
      transfer['destination_movements'].first['quantity'].should eq 1
    end
  end
end
