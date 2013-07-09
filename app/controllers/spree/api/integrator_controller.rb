module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      respond_to :json

      def index
        @since = params[:since] || 1.day.ago
        @orders = orders(@since)
        @count = @orders.count
      end

      private
      def orders(since)
        Spree::Order.complete
                    .ransack(:updated_at_gteq => since).result
                    .page(params[:orders_page])
                    .per(params[:orders_per_page])
                    .order('updated_at ASC')
      end
    end
  end
end
