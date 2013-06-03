module Spree
  module Admin
    class IntegrationController < Spree::Admin::BaseController
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

        # HTTParty.post to see if store is already registered (and get store_if so)
        #
        # if not another post to register
        #

        Spree::Config[:store_id] = '123' #should be real store_id returned either post above.


        redirect_to :action => :show
      end
    end
  end
end
