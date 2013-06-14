# encoding: utf-8

require "spec_helper"

describe Spree::Admin::EndpointMessage do
  subject(:message)     { described_class.new token:      "maggie", 
                                              message:    "batman", 
                                              payload:    payload, 
                                              uri:        uri, 
                                              parameters: parameters }
  let(:uri)             { "http://0.0.0.0" }
  let(:api_request)     { double "API Request" }
  let(:payload_hash)    { { "message_id" => 1 } }
  let(:payload)         { payload_hash.to_json }
  let(:parameters_hash) { { "parameters" => [ { name: "name", key: "key"} ] } }
  let(:parameters)      { parameters_hash.to_json }


  before do
    Spree::Admin::ApiRequest.stub new: api_request
  end

  describe "#payload=" do
    let(:bson_id) { "bson_id" }

    it "should add a message_id" do
      BSON::ObjectId.stub new: double("BSON::ObjectId", to_s: bson_id)
      JSON.stub parse:  {}
      message.payload = {}.to_json
      expect(message.payload).to eq "{\n  \"message_id\": \"#{bson_id}\"\n}"
    end

    it "should replace an empty message_id" do
      JSON.stub parse:  { "message_id" => "" }
      BSON::ObjectId.stub new: double("BSON::ObjectId", to_s: bson_id)
      message.payload = { "message_id" => "" }.to_json
      expect(message.payload).to include("\"message_id\": \"#{bson_id}\"")
    end

    it "should keep the message_id" do
      message_id = "batman"
      BSON::ObjectId.stub new: double("BSON::ObjectId", to_s: bson_id)
      JSON.stub parse:  { "message_id" => message_id }
      message.payload = { "message_id" => message_id }.to_json
      expect(message.payload).to include("\"message_id\": \"#{message_id}\"")
    end

    its(:payload) { eq payload }
    its(:payload_hash) { eq payload_hash }
  end

  describe "#parameters=" do
    its(:payload) { eq payload }
    its(:payload_hash) { eq payload_hash }
  end

  describe "#uri=" do
    it "should append http" do
      message.uri = "0.0.0.0"
      expect(message.uri).to eq "http://0.0.0.0"
    end

    it "should keep http" do
      message.uri = "http://0.0.0.0"
      expect(message.uri).to eq "http://0.0.0.0"
    end

    it "should keep https" do
      message.uri = "https://0.0.0.0"
      expect(message.uri).to eq "https://0.0.0.0"
    end

    it "should ignore when empty" do
      message.uri = ""
      expect(message.uri).to be_empty
    end

    it "should ignore when nil" do
      message.uri = nil
      expect(message.uri).to be_nil
    end
  end

  describe "#save" do
    context "when valid" do
      it "should make a request with empty parameters" do
        message.parameters = nil
        api_request.should_receive(:post).with uri, payload
        message.save
      end

      it "should make a request with parameters" do
        api_request.should_receive(:post).with uri, payload_hash.merge(parameters_hash).to_json
        message.save
      end
    end

    context "when invalid" do
      it "should do nothing" do
        message.stub valid?: false
        api_request.should_not_receive(:post).with uri, payload
        message.save
      end
    end
  end
end

