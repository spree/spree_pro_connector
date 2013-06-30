module Spree
  module Admin
    module EndpointMessagesHelper
      def link_to_clone resource, options={}
        options[:data] = { action: 'clone' } 
        link_to_with_icon('icon-copy', Spree.t(:clone), clone_object_url(resource), options)
      end
    end
  end
end

