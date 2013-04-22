Spree::Api::VariantsController.class_eval do
  helper_method :variant_attributes

  def index
    @variants = scope.includes(:option_values).ransack(params[:q]).result.page(params[:page]).per(params[:per_page])
  end

  private

  def variant_attributes
    [:id, :name, :product_id, :external_ref, :lock_version, :count_on_hand, :sku, :price, :weight, :height, :width, :depth, :is_master, :cost_price, :permalink]
  end
end
