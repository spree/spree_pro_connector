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

    def keys
      response = self.class.get("/stores/#{@store_id}/available_keys", default_headers)
      check_response response
    end

    def integrations
      response = self.class.get("/integrations", default_headers)
      check_response response
    end

    def registrations
      response = self.class.get("/stores/#{@store_id}/registrations", default_headers)
      check_response response
    end

    def parameters
      response = self.class.get("/stores/#{@store_id}/parameters", default_headers)
      check_response response
    end

    private

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
