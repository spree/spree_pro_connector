module Spree::Admin
  class EndpointTestingController < BaseController
    helper_method :collection_url

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
      admin_endpoint_testing_path
    end
  end
end

