module Spree
  module Admin
    class EventsController < Spree::Admin::BaseController
      respond_to :html

      def index
        @order = Order.find_by_number!(params[:order_id])
        @integration_url = case Rails.env
          when 'development'
            "http://augury-admin.dev"
          when 'staging'
                  "http://aug-stg1.spree.mx"
          when 'production'
                  "http://aug-app1.spree.mx"
          end

      end
    end
  end
end
