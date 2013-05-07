object false

child(:orders => :orders) do
  child(@orders => :page) do
    attributes *order_attributes

    child :billing_address => :bill_address do
      extends "spree/api/addresses/show"
    end

    child :shipping_address => :ship_address do
      extends "spree/api/addresses/show"
    end

    child :line_items => :line_items do
      extends "spree/api/line_items/show"
    end

    child :payments => :payments do
      attributes :id, :amount, :state, :payment_method_id
      child :payment_method => :payment_method do
        attributes :id, :name, :environment
      end
    end

    child :shipments => :shipments do
      extends "spree/api/shipments/show"
    end

    child :adjustments => :adjustments do
      attributes :id, :amount, :label, :mandatory, :locked, :eligible, :originator_type, :adjustable_type
    end

    child :credit_cards => :credit_cards do
      attributes :id, :month, :year, :cc_type, :last_digits, :first_name, :last_name, :gateway_customer_profile_id, :gateway_payment_profile_id
    end
  end

  node(:count) { @orders.count }
  node(:current_page) { params[:orders_page] || 1 }
  node(:pages) { @orders.num_pages }
end

child(:stock_transfers => :stock_transfers) do
  child(@stock_transfers => :page) do
    attributes *stock_transfer_attributes

    child :source_location => :source_location do
      attributes :name
      extends "spree/api/addresses/show"
    end

    child :source_movements => :source_movements do
      attributes *stock_movement_attributes
      child :stock_item do
        extends "spree/api/stock_items/show"
      end
    end

    child :destination_location => :destination_location do
      attributes :name
      extends "spree/api/addresses/show"
    end

    child :destination_movements => :destination_movements do
      attributes *stock_movement_attributes
      child :stock_item do
        extends "spree/api/stock_items/show"
      end
    end
  end

  node(:count) { @stock_transfers.count }
  node(:current_page) { params[:stock_transfers_page] || 1 }
  node(:pages) { @stock_transfers.num_pages }
end
