# encoding: utf-8

module Spree::Admin
  class ApiRequest
    def self.post token, uri, body
      response_hash(HTTParty.post(uri, {
        body: body,
        headers: { "X-Augury-Token" => token }
      }))
    end

    private
    def self.response_hash response
      { code: response.code,
        body: response.body,
        headers: response.headers
      }
    end
  end
end

