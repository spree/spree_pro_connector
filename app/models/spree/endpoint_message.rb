module Spree
  class EndpointMessage < ActiveRecord::Base
    serialize :response_data

    validates :payload    , presence: true , json: true
    validates :uri        , presence: true
    validates :token      , presence: true
    validates :parameters , json: true

    validate :validates_uniqueness_of_message_id

    attr_accessible :message, :uri, :token, :payload, :parameters

    default_scope order: "created_at DESC"

    def uri=uri
      uri = "http://#{uri}" if !uri.blank? && !uri.match(/^https?:\/\//)
      write_attribute :uri, uri
    end

    def payload=payload
      write_attribute :payload, payload
      payload_hash = JSON.parse payload
      write_message_id(payload_hash) if payload_hash["message_id"].blank?
      write_attribute :message_id, payload_hash["message_id"]
      write_attribute :message,    payload_hash["message"]
      write_attribute :payload,    JSON.pretty_generate(payload_hash)
    rescue JSON::ParserError
    end

    def send_request request_client=Spree::Admin::ApiRequest
      return unless valid?
      write_attribute :response_data, request_client.post(token, uri, full_payload)
      save
    end

    def response_headers
      response_data[:headers]
    end

    def response_code
      response_data[:code]
    end

    def response_body
      response_data[:body]
    end

    def update_message_id!
      payload_hash = JSON.parse payload
      payload_hash.delete "message_id"
      self.payload = payload_hash.to_json
    end

    def self.unique_messages
      uniq.pluck(:message)
    end

    private :save, :create

    private

    def validates_uniqueness_of_message_id
      relation = self.class.where(message_id: message_id)
      relation = relation.where(self.class.arel_table[:id].not_eq(id)) if persisted?

      if endpoint_message = relation.first
        errors.add :message_id,
          Spree.t("endpoint_message.errors.taken",
                  url: Spree::Core::Engine.routes.url_helpers.edit_admin_endpoint_message_path(endpoint_message),
                  id: endpoint_message.id)
      end
    end

    def parameters_hash
      JSON.parse parameters unless parameters.blank?
    end

    def write_message_id target_hash
      target_hash["message_id"] = BSON::ObjectId.new.to_s
    end

    def full_payload
      JSON.parse(payload).merge(parameters_hash || {}).to_json
    end
  end
end

