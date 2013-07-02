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
      uri = "http://#{uri}" if uri.present? && !uri.match(/^https?:\/\//)
      write_attribute :uri, uri
    end

    def payload=payload
      write_attribute :payload, payload
      @payload_hash = nil
      return unless payload_hash
      update_payload
    end

    def parameters=parameters
      write_attribute :parameters, parameters
      @parameters_hash = nil
      return unless parameters_hash
      write_attribute(:parameters, JSON.pretty_generate(parameters_hash))
    end

    def send_request request_client=Spree::Admin::ApiRequest
      return unless valid?
      write_attribute :response_data, request_client.post(token, uri, full_payload)
      save
    end

    def duplicate
      clone = dup.tap do |new_clone|
        new_clone.response_data = nil
        new_clone.update_message_id!
      end
      clone.save
      clone
    end

    def response_headers
      response_data[:headers]
    end

    def response_code
      response_data && response_data[:code]
    end

    def response_code_class
      # Returns the class of the response status code.
      case response_code.to_s
      when /^2[0-9]{2}$/
        "success"
      when /^4[0-9]{2}$/
        "client-error"
      when /^5[0-9]{2}$/
        "server-error"
      else
        "other"
      end
    end

    def response_body
      response_data[:body]
    end

    def response_time
      response_data[:response_time]
    end

    def update_message_id!
      payload_hash.delete "message_id"
      update_payload
    end

    def self.unique_messages
      uniq.pluck :message
    end

    protected :save, :create

    private

    def payload_hash
      @payload_hash ||= to_hash payload
    end

    def parameters_hash
      @parameters_hash ||= to_hash parameters
    end


    def to_hash data
      JSON.parse(data) if data
    rescue JSON::ParserError
    end

    def update_payload
      write_message_id if payload_hash["message_id"].blank?
      write_attribute :message_id, payload_hash["message_id"]
      write_attribute :message,    payload_hash["message"]
      write_attribute :payload,    JSON.pretty_generate(payload_hash)
    end

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

    def write_message_id
      payload_hash["message_id"] = BSON::ObjectId.new.to_s
    end

    def full_payload
      payload_hash.merge(parameters_hash || {}).to_json
    end
  end
end

