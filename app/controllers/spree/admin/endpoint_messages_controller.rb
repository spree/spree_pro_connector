module Spree::Admin
  class EndpointMessagesController  < ResourceController
    before_filter :update_message_id , only: :edit
    before_filter :load_data         , only: [:new, :edit]

    helper_method :clone_object_url

    create.fails :load_data
    update.fails :load_data

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
        flash[:success] = flash_message_for(@endpoint_message, :successfully_sent)
        redirect_to edit_admin_endpoint_message_path(@endpoint_message)
      else
        invoke_callbacks(:create, :fails)
        render :new
      end
    end

    def update
      @endpoint_message = Spree::EndpointMessage.find params[:id]
      @endpoint_message.assign_attributes params[:endpoint_message]
      @endpoint_message.parameters_hash = parse_parameters(params[:new_parameter_pairs])
      if @endpoint_message.send_request
        flash[:success] = flash_message_for(@endpoint_message, :successfully_sent)
        redirect_to edit_admin_endpoint_message_path(@endpoint_message)
      else
        invoke_callbacks(:update, :fails)
        render :edit
      end
    end

    def clone
      @clone = Spree::EndpointMessage.find(params[:id]).duplicate
      flash[:success] = Spree.t 'notice_messages.message_cloned'
      redirect_to edit_object_url @clone
    end

    protected

      def clone_object_url(resource)
        clone_admin_endpoint_message_url(resource)
      end

      def load_data
        @environment = AuguryEnvironment.where(id: Spree::Config.augury_current_env).first
        @presenter   = EndpointTestingPresenter.new(@endpoint_message, @environment)
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

