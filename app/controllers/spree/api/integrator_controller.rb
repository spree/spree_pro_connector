module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      respond_to :json

      def index
        @since = params[:since] || 1.day.ago
        @orders = orders(@since)
        @count = @orders.count
      end

      def add_stock
        @variant = Spree::Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i

        if @variant.count_on_hand > 0
          quantity += @variant.count_on_hand
        end
        @variant.update_attribute(:count_on_hand, quantity)
      end

      private
      def orders(since)
        Spree::Order.complete
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:page]).per(params[:per_page])
      end
    end
  end
end
