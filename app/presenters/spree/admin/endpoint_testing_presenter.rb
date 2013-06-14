require "samples"

module Spree::Admin
  class EndpointTestingPresenter
    delegate :uri, :response_code, :response_body, :response_headers, :response, 
      to: :@message

    def initialize message
      @message = message
    end

    def samples
      [
        OpenStruct.new(message: "order:persist"          , payload: Samples::Order.persist)          ,
        OpenStruct.new(message: "order:ship"             , payload: Samples::Order.ship)             ,
        OpenStruct.new(message: "order:capture"          , payload: Samples::Order.capture)          ,
        OpenStruct.new(message: "order:payment:captured" , payload: Samples::Order.payment_captured) ,
        OpenStruct.new(message: "shipment:confirmation"  , payload: Samples::Shipment.confirmation)
      ]
    end

    def each_response_data
      { uri: uri, code: response_code, body: response_body}.
        merge(response_headers)
      .each do |key, value|
        yield key, value.kind_of?(Array) ? value.join(", ") :
          value
      end
    end

    def response_json?
      response_headers["Content-Type"].include? "application/json"
    end
  end
end


