module Spree::Admin
  class EndpointMessagesController  < ResourceController
    before_filter :load_data         , only: [:new, :create, :edit, :update]
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
      @endpoint_message.parameters_hash = parse_parameters(params[:new_parameter_pairs])
      if @endpoint_message.send_request
        redirect_to edit_admin_endpoint_message_path(@endpoint_message)
      else
        render :new
      end
    end

    def update
      @endpoint_message = Spree::EndpointMessage.find params[:id]
      @endpoint_message.assign_attributes params[:endpoint_message]
      @endpoint_message.parameters_hash = parse_parameters(params[:new_parameter_pairs])
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

    def load_data
      @presenter = EndpointTestingPresenter.new @endpoint_message
      # copied from app/controllers/spree/admin/integration_controller.rb#show
      if @environment = AuguryEnvironment.where(id: Spree::Config.augury_current_env).first
        preloader = SpreeProConnector::Preloader.new(@environment.url,
                                                     @environment.store_id,
                                                     @environment.token)
        @parameters_json = preloader.parameters
      end
    end

    def update_message_id
      @endpoint_message.update_message_id!
    end

    private

    def parse_parameters parameters
      { "parameters" => (parameters || {}).values }
    end
  end
end

