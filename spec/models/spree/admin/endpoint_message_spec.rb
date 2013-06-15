require "spec_helper"

describe Spree::Admin::EndpointMessage do
  subject(:message)     { described_class.new token: token,
                          message:    "batman",
                          uri:        uri,
                          payload:    payload,
                          parameters: parameters }

  let(:uri)             { "http://0.0.0.0" }
  let(:token)           { "maggie" }

  let(:payload_hash)    { { "message_id" => "1a" } }
  let(:payload)         { "{\"message_id\":\"1a\"}" }

  let(:parameters_hash) { { "parameters" => [ { "name" => "name", "key" => "key"} ] } }
  let(:parameters)      { "{ \"parameters\":[  { \"name\":\"name\",\"key\":\"key\"}]}" }

  let(:api_request)     { double "API Request" }

  before do
    BSON::ObjectId.stub new: "1b"
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

  describe "#payload=" do
    it "prettifies payload" do
      message.payload = "{\"key\":\"key\",\"keys\":[{\"key\":\"key\"}]}"
      expect(message.payload).to eq "{\n  \"key\": \"key\",\n  \"keys\": [\n    {\n      \"key\": \"key\"\n    }\n  ],\n  \"message_id\": \"1b\"\n}"
    end

    it "appends message_id" do
      message.payload = "{}"
      expect(message.payload).to eq "{\n  \"message_id\": \"1b\"\n}"
    end
  end

  describe "#send_request" do
    it "sends request with payload" do
      message.parameters = nil
      api_request.should_receive(:post).with token, uri, payload
      message.send_request api_request
    end

    it "sends request with payload and parameters" do
      api_request.should_receive(:post).with token, uri, "{\"message_id\":\"1a\",\"parameters\":[{\"name\":\"name\",\"key\":\"key\"}]}"
      message.send_request api_request
    end
  end
end
