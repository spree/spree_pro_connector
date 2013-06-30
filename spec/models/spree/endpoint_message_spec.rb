require "spec_helper"

describe Spree::EndpointMessage do
  subject(:message)     { described_class.new token: token,
                          message:    "batman",
                          uri:        uri,
                          payload:    payload,
                          parameters: parameters }

  let(:uri)             { "http://0.0.0.0" }
  let(:token)           { "maggie" }

  let(:payload_hash)    { { "message_id" => "1a" } }
  let(:payload)         { %Q{{"message_id":"1a"}} }

  let(:parameters_hash) { { "parameters" => [ { "name" => "name", "key" => "key"} ] } }
  let(:parameters)      { %Q{{ "parameters":[  { "name":"name","key":"key"}]}} }

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

  describe "#update_message_id!" do
    before do
      message.payload = %Q{{"message_id":"homer"}}
      message.update_message_id!
    end

    its(:message_id) { should eq "1b" }
    its(:payload)    { should eq %Q{{\n  "message_id": "1b"\n}} }
  end

  describe "#duplicate" do
    subject(:clone) { message.duplicate }

    its(:response_data) { should be_nil }
    its(:message_id)    { should_not eq message.message_id }
    its(:persisted?)    { should be }
  end

  describe "#parameters=" do
    it "prettifies parameters" do
      message.parameters = %Q{{"key":"key","keys":[{"key":"key"}]}}
      expect(message.parameters).to eq %Q{{\n  "key": "key",\n  "keys": [\n    {\n      "key": "key"\n    }\n  ]\n}}
    end

    it "skips invalid" do
      message.parameters = "homer"
      expect(message.parameters).to eq "homer"
    end

    it "skips nil" do
      message.parameters = nil
      expect(message.parameters).to be_nil
    end
  end

  describe "#payload=" do
    it "prettifies payload" do
      message.payload = %Q{{"key":"key","keys":[{"key":"key"}]}}
      expect(message.payload).to eq %Q{{\n  "key": "key",\n  "keys": [\n    {\n      "key": "key"\n    }\n  ],\n  "message_id": "1b"\n}}
    end

    it "skips invalid" do
      message.payload = "homer"
      expect(message.payload).to eq "homer"
    end

    it "skips nil" do
      message.payload = nil
      expect(message.payload).to be_nil
    end

    it "appends message_id" do
      message.payload = "{}"
      expect(message.payload).to eq %Q{{\n  "message_id": "1b"\n}}
    end
  end

  describe "#send_request" do
    it "sends request with payload" do
      message.parameters = nil
      api_request.should_receive(:post).with token, uri, payload
      message.send_request api_request
    end

    it "sends request with payload and parameters" do
      api_request.should_receive(:post).with token, uri, %Q{{"message_id":"1a","parameters":[{"name":"name","key":"key"}]}}
      message.send_request api_request
    end
  end
end

