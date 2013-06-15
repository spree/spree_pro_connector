module Spree::Admin
  class EndpointTestingController < BaseController
    helper_method :collection_url, :new_object_url

    def index
      @messages = EndpointMessage.all
    end

    def new
      @message   = EndpointMessage.new
      @presenter = EndpointTestingPresenter.new @message
    end

    def create
      @message   = EndpointMessage.new params[:admin_endpoint_message]
      @message.send_request

      @presenter = EndpointTestingPresenter.new @message

      render :new
    end

    private

    def collection_url
      admin_endpoint_testings_path
    end

    def new_object_url
      admin_endpoint_testing_path
    end
  end
end

