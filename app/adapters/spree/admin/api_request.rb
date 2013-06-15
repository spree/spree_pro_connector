# encoding: utf-8

module Spree::Admin
  class ApiRequest
    def self.post token, uri, body
      HTTParty.post(uri, {
        body: body,
        headers: { "X-Augury-Token" => token }
      })
    end
  end
end

