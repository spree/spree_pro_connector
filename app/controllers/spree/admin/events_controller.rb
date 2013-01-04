module Spree
  module Admin
    class EventsController < Spree::Admin::BaseController
      respond_to :html

      def index
        @order = Order.find_by_number!(params[:order_id])
      end
    end
  end
end
