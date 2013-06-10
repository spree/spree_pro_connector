module Spree::Admin
  class EndpointTestingController < BaseController
    helper_method :collection_url

    def new
      message    = Message.new
      @presenter = EndpointTestingPresenter.new message
    end

    def create
      message    = Message.new params[:admin_message]
      @presenter = EndpointTestingPresenter.new message
      @presenter.save

      render :new
    end

    private

    def collection_url
      admin_endpoint_testing_path
    end
  end
end

