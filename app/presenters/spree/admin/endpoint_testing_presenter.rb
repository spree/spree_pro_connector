require "samples"

module Spree::Admin
  class EndpointTestingPresenter
    delegate :uri, :response_code, :response_body, :response_headers, :response_data, :response_code_class,
      to: :@endpoint_message

    def initialize(endpoint_message, environment)
      @endpoint_message = endpoint_message
      @environment      = environment
    end

    def samples
      Samples.all
    end

    def each_parameter_hash_with_index
      @endpoint_message.parameters_hash["parameters"].each_with_index do |parameter_hash, index|
        yield parameter_hash, index
      end
    end

    def available_services
      @available_services ||= begin
                                global_integrations = JSON.parse(preloader.global_integrations)
                                global_integrations.map do |integration|
                                  (integration["consumers"] || []).map do |consumer|
                                    create_consumer_struct(integration, consumer)
                                  end
                                end
                              end.flatten
    end

    def parameters_json
      @parameters_json ||= preloader.parameters
    end

    def each_response_data
      response_headers.each do |key, value|
        yield key, value.kind_of?(Array) ? value.join(", ") : value
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
      @endpoint_message.response_time.to_f.round 2
    end

    private

      def preloader
        @preloader ||= if @environment
                         SpreeProConnector::Preloader.new(@environment.url,
                                                          @environment.store_id,
                                                          @environment.token)
                       else
                         # Null Object
                         OpenStruct.new(global_integrations: "{}", parameters: "{}")
                       end
      end

      def create_consumer_struct(integration, consumer)
        OpenStruct.new(
          name:      "#{integration["name"]}##{consumer["name"]}",
          full_url:  "#{integration["url"]}#{consumer["path"]}",
          payload:   consumer.to_json)
      end
  end
end

