module Spree::Admin
  class Message
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    delegate :code, :body, :headers, to: :response, prefix: true

    attr_accessor :uri, :payload, :message, :response, :token, :parameters

    validates :payload    , presence: true , json: true
    validates :uri        , presence: true
    validates :token      , presence: true
    validates :parameters , json: true

    def initialize attributes = {}
      attributes.each do |name, value|
        send "#{name}=", value
      end
    end

    def persisted?
      false
    end

    def uri=_uri
      @uri = _uri
      @uri = "http://#{@uri}" if !@uri.blank? && !@uri.match(/^https?:\/\//)
    end

    def payload=_payload
      @payload = _payload
      @payload_hash, @payload = create_payload_hash(@payload)
      adds_message_id_for(@payload_hash) if @payload_hash
    end

    def parameters=_parameters
      @parameters = _parameters
      @parameters_hash, @parameters = create_payload_hash(@parameters)
    end

    def save
      return unless valid?
      @response = ApiRequest.new(token).post uri, full_payload
    end

    private

    def create_payload_hash payload
      payload_hash = JSON.parse payload
      [payload_hash, JSON.pretty_generate(payload_hash)]
    rescue
    end

    def adds_message_id_for target_hash
      return unless target_hash["message_id"].blank?
      target_hash.delete "message_id"
      target_hash.reverse_merge!({ "message_id" => BSON::ObjectId.new.to_s })
    end

    def full_payload
      @payload_hash.merge(@parameters_hash || {}).to_json
    end
  end
end

