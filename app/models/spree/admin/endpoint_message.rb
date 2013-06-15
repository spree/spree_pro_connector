module Spree::Admin
  class EndpointMessage < ActiveRecord::Base
    self.table_name = "spree_endpoint_messages"

    delegate :code, :body, :headers, to: :response, prefix: true

    attr_accessor :response

    validates :payload    , presence: true , json: true
    validates :uri        , presence: true
    validates :token      , presence: true
    validates :parameters , json: true

    attr_accessible :message, :uri, :token, :payload, :parameters

    def uri=uri
      uri = "http://#{uri}" if !uri.blank? && !uri.match(/^https?:\/\//)
      write_attribute :uri, uri
    end

    def payload=payload
      write_attribute :payload, payload
      payload_hash = JSON.parse payload
      payload_hash = add_message_id(payload_hash) if payload_hash["message_id"].blank?
      write_attribute :payload, JSON.pretty_generate(payload_hash)
    rescue JSON::ParserError
    end

    def send_request
      return unless valid?
      @response = ApiRequest.new(token).post uri, full_payload
    end

    private :save, :create

    private

    def parameters_hash
      JSON.parse parameters unless parameters.blank?
    end

    def add_message_id target_hash
      { "message_id" => BSON::ObjectId.new.to_s }.reverse_merge target_hash
    end

    def full_payload
      JSON.parse(payload).merge(parameters_hash || {}).to_json
    end
  end
end

