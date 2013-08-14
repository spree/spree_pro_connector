require 'httparty'

module SpreeProConnector
  class PreloadError < Exception; end

  class Preloader
    include HTTParty

    attr_accessor :base_url, :store_id, :api_key

    def initialize(base_url, store_id, api_key)
      self.class.base_uri "#{base_url}/api"
      @store_id = store_id
      @api_key = api_key
    end

    def messages
      load_resource "/stores/#{@store_id}/available_messages"
    end

    def integrations
      load_resource "/stores/#{@store_id}/integrations"
    end

    def mappings
      load_resource "/stores/#{@store_id}/mappings"
    end

    def schedulers
      load_resource "/stores/#{@store_id}/schedulers"
    end

    def parameters
      load_resource "/stores/#{@store_id}/parameters"
    end


    private

    def load_resource(resource_url)
      begin
        response = self.class.get(resource_url, default_headers)
        check_response response
      rescue Errno::ECONNREFUSED
        raise PreloadError
      end
    end

    def default_headers
      { :headers => { "X-Augury-Token" => @api_key } }
    end

    def check_response(response)
      case response.code
      when 200
        response.to_json
      else
        raise PreloadError
      end
    end
  end
end
