module Spree
  module Admin
    class IntegrationController < Spree::Admin::BaseController
      include HTTParty
      base_uri 'http://augury.dev/api'

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
                url: request.url,
                version: Spree.version,
                api_key: user.spree_api_key,
                email: email,
              }
            }
          }

          response = self.class.post('/signups.json', options)
          if response.code == 201
            Spree::Config[:store_id] = response["store_id"]
            Spree::Config[:pro_api_key] = response["auth_token"]
          end
        end

        redirect_to :action => :show
      end
    end
  end
end
