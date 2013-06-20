module Spree::Admin
  class EndpointMessagesController  < ResourceController
    before_filter :load_presenter, only: [:new, :create, :edit, :update]

    def index
      @search = Spree::EndpointMessage.ransack(params[:q])
      @endpoint_messages = @search.result.
        page(params[:page]).
        per(params[:per_page])
    end

    def load_presenter
      @presenter = EndpointTestingPresenter.new @endpoint_message
    end

    def create
      @endpoint_message = Spree::EndpointMessage.new params[:endpoint_message]
      if @endpoint_message.send_request
        redirect_to edit_admin_endpoint_message_path(@endpoint_message)
      else
        render :new
      end
    end

    def update
      @endpoint_message = Spree::EndpointMessage.find params[:id]
      @endpoint_message.assign_attributes params[:endpoint_message]

      if @endpoint_message.send_request
        redirect_to edit_admin_endpoint_message_path(@endpoint_message)
      else
        render :edit
      end
    end
  end
end

