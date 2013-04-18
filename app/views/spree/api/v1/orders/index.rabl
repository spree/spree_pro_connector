object false
child(@orders) do
  attributes *order_attributes

  child :billing_address => :bill_address do
    extends "spree/api/v1/addresses/show"
  end

  child :shipping_address => :ship_address do
    extends "spree/api/v1/addresses/show"
  end

  child :line_items => :line_items do
    extends "spree/api/v1/line_items/show"
  end

  child :payments => :payments do
    attributes :id, :amount, :state, :payment_method_id
    child :payment_method => :payment_method do
      attributes :id, :name, :environment
    end
  end

  child :shipments => :shipments do
    extends "spree/api/v1/shipments/show"
  end

  child :adjustments => :adjustments do
    attributes :id, :amount, :label, :mandatory, :locked, :eligible, :originator_type, :adjustable_type
  end

  child :credit_cards => :credit_cards do
    attributes :id, :month, :year, :cc_type, :last_digits, :first_name, :last_name, :gateway_customer_profile_id, :gateway_payment_profile_id
  end
end

node(:count) { @orders.count }
node(:current_page) { params[:page] || 1 }
node(:pages) { @orders.num_pages }
