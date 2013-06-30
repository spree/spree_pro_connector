module Spree::Admin
  class EndpointMessagesController  < ResourceController
    before_filter :load_presenter    , only: [:new, :create, :edit, :update]
    before_filter :update_message_id , only: :edit

    helper_method :clone_object_url

    def index
      @search = Spree::EndpointMessage.ransack(params[:q])
      @endpoint_messages = @search.result.
        page(params[:page]).
        per(params[:per_page])
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

    def clone
      @clone = Spree::EndpointMessage.find(params[:id]).duplicate
      flash[:success] = Spree.t 'notice_messages.message_cloned'
      redirect_to edit_object_url @clone
    end

    protected

    def clone_object_url resource
      clone_admin_endpoint_message_url resource
    end

    def load_presenter
      @presenter = EndpointTestingPresenter.new @endpoint_message
    end

    def update_message_id
      @endpoint_message.update_message_id!
    end
  end
end

