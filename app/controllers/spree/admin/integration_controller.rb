require 'spree_pro_connector/preloader'

module Spree
  module Admin
    class IntegrationController < Spree::Admin::BaseController
      rescue_from SpreeProConnector::PreloadError, with: :preload_error

        def register
          email = 'integrator@spreecommerce.com'
          if user = Spree::User.where('email' => email).first
    # do nothing, for now....
        else
          passwd = SecureRandom.hex(32)
          user = Spree::User.create('email' => email,
                                    'password' => passwd,
                                    'password_confirmation' => passwd)

          user.spree_roles << Spree::Role.all
          user.generate_spree_api_key!
        end

        # Register Store if Spree::Config[:store_id] isn't present
        unless Spree::Config[:store_id].present?
          options = {
            body: {
              signup: {
                name: Spree::Config[:site_name],
                url: "http://#{request.host_with_port}/api",
                version: Spree.version,
                api_key: user.spree_api_key,
                email: email,
              }
            }
          }

          response = HTTParty.post("#{Spree::Config.pro_url}/api/signups.json", options)

          if response.code == 201
            Spree::Config[:store_id] = response["store_id"]
            Spree::Config[:pro_api_key] = response["auth_token"]
          else
            flash[:error] = "We're unable to complete your registration at this time
              , please try again later."
          end
        end

        redirect_to :action => :show
      end

      def show
        if Spree::Config.store_id.present? && Spree::Config.pro_api_key.present?
          preloader = SpreeProConnector::Preloader.new(Spree::Config.pro_url,
                                                       Spree::Config.store_id,
                                                       Spree::Config.pro_api_key)
          @keys_json = preloader.keys
          @integrations_json = preloader.integrations
          @registrations_json = preloader.registrations
          @parameters_json = preloader.parameters
        end
      end

      private

      def preload_error
        flash[:error] = "There was a problem loading Augury data. Please try again."
        render :show
      end
    end
  end
end
