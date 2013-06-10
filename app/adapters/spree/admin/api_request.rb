# encoding: utf-8

module Spree::Admin
  class ApiRequest
    def initialize token
      @token = token
    end

    def post uri, body
      HTTParty.post(uri, {
        body: body,
        headers: { "X-Augury-Token" => @token }
      })
    end
  end
end

