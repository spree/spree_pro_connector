require "spec_helper"

describe Spree::Admin::EndpointMessage do
  subject(:message)     { described_class.new token: "maggie",
                          message:    "batman",
                          payload:    payload,
                          uri:        uri,
                          parameters: parameters }

  let(:uri)             { "http://0.0.0.0" }
  let(:api_request)     { double "API Request" }
  let(:payload_hash)    { { "message_id" => "1a" } }
  let(:payload)         { payload_hash.to_json }
  let(:parameters_hash) { { "parameters" => [ { name: "name", key: "key"} ] } }
  let(:parameters)      { parameters_hash.to_json }


  before do
    Spree::Admin::ApiRequest.stub new: api_request
  end

  describe "#uri=" do
    it "appends http" do
      message.uri = "0.0.0.0"
      expect(message.uri).to eq "http://0.0.0.0"
    end

    it "keeps http" do
      message.uri = "http://0.0.0.0"
      expect(message.uri).to eq "http://0.0.0.0"
    end

    it "keeps https" do
      message.uri = "https://0.0.0.0"
      expect(message.uri).to eq "https://0.0.0.0"
    end

    it "ignores empty" do
      message.uri = ""
      expect(message.uri).to be_empty
    end

    it "ignores nil" do
      message.uri = nil
      expect(message.uri).to be_nil
    end
  end

  describe "#send_request" do
    it "sends request with payload" do
      message.parameters = nil
      api_request.should_receive(:post).with uri, "{\"message_id\":\"1a\"}"
      message.send_request
    end

    it "sends request with payload and parameters" do
      api_request.should_receive(:post).with uri, "{\"message_id\":\"1a\",\"parameters\":[{\"name\":\"name\",\"key\":\"key\"}]}"
      message.send_request
    end

    it "appends message_id" do
      BSON::ObjectId.stub new: "2b"
      message.payload = "{}"
      api_request.should_receive(:post).with uri, "{\"message_id\":\"2b\",\"parameters\":[{\"name\":\"name\",\"key\":\"key\"}]}"
      message.send_request
    end
  end
end
