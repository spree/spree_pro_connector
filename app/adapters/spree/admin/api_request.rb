# encoding: utf-8

module Spree::Admin
  class ApiRequest
    def self.post(token, uri, body)
      start = Time.now
      response_hash(HTTParty.post(uri, {
        body: body,
        headers: { "X-Augury-Token" => token }
      })).merge({ response_time: Time.now - start })
    rescue => e
      { code: 0, body: e.message, headers: {}, response_time: 0.0 }
    end

    private
    def self.response_hash(response)
      { code: response.code,
        body: response.body,
        headers: response.headers
      }
    end
  end
end

