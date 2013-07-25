Spree::Api::V1::OrdersController.class_eval do
  helper_method :variant_attributes, :order_attributes

  private

  def variant_attributes
    [:id, :name, :product_id, :external_ref, :sku, :price, :weight, :height, :width, :depth, :is_master, :cost_price, :permalink]
  end

  def order_attributes
    [:id,
     :number,
     :item_total,
     :total,
     :state,
     :adjustment_total,
     :user_id,
     :created_at,
     :updated_at,
     :completed_at,
     :payment_total,
     :shipment_state,
     :payment_state,
     :email,
     :special_instructions,
     :ship_total,
     :tax_total,
     :total_weight,
     :locked_at]
  end
end
