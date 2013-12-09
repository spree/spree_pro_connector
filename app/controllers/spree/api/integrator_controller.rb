module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController

      before_filter :authorize_read! 

      helper_method :variant_attributes,
                    :order_attributes,
                    :stock_transfer_attributes

      respond_to :json

      def index
        @since = params[:since] || 1.day.ago
        @orders = orders @since
        @stock_transfers = stock_transfers(@since)
      end

      private

      
      def authorize_read!
         user = try_spree_current_user || current_api_user
 
         unless user && user.has_spree_role?("admin")
           raise CanCan::AccessDenied
         end
      end

      def orders(since)
        Spree::Order.complete
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:orders_page])
                    .per(params[:orders_per_page])
                    .order('updated_at ASC')
      end

      def stock_transfers(since)
        Spree::StockTransfer
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:stock_transfers_page])
                    .per(params[:stock_transfers_per_page])
                    .order('updated_at ASC')
      end

      def variant_attributes
        [:id, :name, :product_id, :external_ref, :sku, :price, :weight, :height, :width, :depth, :is_master, :cost_price, :permalink]
      end

      def order_attributes
        [:id, :number, :item_total, :total, :state, :adjustment_total, :user_id, :created_at, :updated_at, :completed_at, :payment_total, :shipment_state, :payment_state, :email, :special_instructions, :total_weight, :locked_at]
      end

     def stock_transfer_attributes
        [:id, :reference_number, :number, :created_at, :updated_at]
      end
    end
  end
end
