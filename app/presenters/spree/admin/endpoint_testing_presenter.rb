require "samples"

module Spree::Admin
  class EndpointTestingPresenter
    delegate :uri, :response_code, :response_body, :response_headers, :response_data, :response_code_class,
      to: :@endpoint_message

    def initialize endpoint_message
      @endpoint_message = endpoint_message
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
      response_headers.each do |key, value|
        yield key, value.kind_of?(Array) ? value.join(", ") :
          value
      end
    end

    def response_html_safe
      response_body.gsub "script", "xcriptx"
    end

    def response_json
      JSON.pretty_generate JSON.parse(response_body)
    end

    def response_json?
      response_headers.fetch("Content-Type", "").include? "application/json"
    end

    def response_time
      @endpoint_message.response_time.round 2
    end
  end
end


