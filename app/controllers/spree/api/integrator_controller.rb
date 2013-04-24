module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      respond_to :json

      def index
        @since = params[:since]
        @orders = orders(@since)
        @count = @orders.count
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
