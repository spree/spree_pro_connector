require 'spree_pro_connector/preloader'

module Spree
  module Admin
    class IntegrationController < Spree::Admin::BaseController
      rescue_from SpreeProConnector::PreloadError, with: :preload_error

      def register
        env = AuguryEnvironment.create(store_id: params[:store_id],
                                       url: params[:url],
                                       user: params[:user],
                                       token: params[:user_token],
                                       environment: params[:env])
        Spree::Config.augury_current_env = env.id

        redirect_to :action => :show
      end

      def connect
        Spree::Config.augury_current_env = params[:env_id]
        redirect_to :action => :show
      end

      def disconnect
        Spree::Config.augury_current_env = nil
        redirect_to :action => :show
      end

      def show
        email = 'integrator@spreecommerce.com'
        if @integrator_user = Spree::User.where('email' => email).first
          # do nothing, for now....
        else
          passwd = SecureRandom.hex(32)
          @integrator_user = Spree::User.create('email' => email,
                                    'password' => passwd,
                                    'password_confirmation' => passwd)

          @integrator_user.spree_roles << Spree::Role.all
          @integrator_user.generate_spree_api_key!
        end

        if @environment = AuguryEnvironment.where(id: Spree::Config.augury_current_env).first
          preloader = SpreeProConnector::Preloader.new(@environment.url,
                                                       @environment.store_id,
                                                       @environment.token)

          @keys_json = preloader.keys
          @store_integrations_json = preloader.store_integrations
          @global_integrations_json = preloader.global_integrations
          @registrations_json = preloader.registrations
          @schedulers_json = preloader.schedulers
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
