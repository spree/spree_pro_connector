module Spree
  module Admin
    class NotificationsController < Spree::Admin::BaseController
      respond_to :html

      def index
        @order = Order.find_by_number!(params[:order_id])

        @environment = AuguryEnvironment.where(id: Spree::Config.augury_current_env).first

        @integration_url = case Rails.env
                           when 'development'
                             'http://localhost:3000'
                           when 'staging'
                             'http://aug-stg1.spree.mx'
                           when 'production'
                             'http://aug-app1.spree.mx'
                           end
      end
    end
  end
end
