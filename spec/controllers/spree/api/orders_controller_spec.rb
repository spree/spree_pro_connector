require 'spec_helper'

module Spree
  module Api
    describe OrdersController do

      it 'adds custom variant attributes' do
        attr = controller.send(:variant_attributes)
        attr.should include(:external_ref)
        attr.should include(:product_id)
      end
    end
  end
end
