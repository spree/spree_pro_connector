require "spec_helper"

describe Spree::EndpointMessage do
  subject(:message)     { described_class.new token: token,
                          message:    "batman",
                          uri:        uri,
                          payload:    payload }

  let(:uri)             { "http://0.0.0.0" }
  let(:token)           { "maggie" }

  let(:payload_hash)    { { "message_id" => "1a" } }
  let(:payload)         { %Q{{"message":"test:test","message_id":"1a"}} }

  let(:parameters_hash) { { "parameters" => [ { "name" => "name", "key" => "key"} ] } }
  let(:parameters)      { %Q{{"parameters":[{"name":"name","key":"key"}]}}}

  let(:api_request)     { double "API Request" }

  before do
    BSON::ObjectId.stub new: "1b"
  end

  describe "#response_code_class" do
    { "success"      => [200, 250, 299],
      "client-error" => [400, 450, 499],
      "server-error" => [500, 550, 599],
      "other"        => [100, 150, 199, 300, 350, 399, nil] }.each_pair do |key, codes|

        codes.each do |code|
          it "returns #{key} for #{code}" do
            message.stub response_code: code
            expect(message.response_code_class).to eq key
          end
        end
      end
  end

  describe "#uri=" do
    it "sets an uri" do
      uri = "0.0.0.0"
      http_uri = "http://0.0.0.0"
      message.should_receive(:write_attribute).with(:uri, http_uri)
      message.uri = uri
      expect(message.uri).to eq http_uri
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

  describe "#parameters_hash=" do
    it "prettifies parameters" do
      message.parameters_hash = parameters_hash
      expect(message.parameters).to eq %Q{{\n  \"parameters\": [\n    {\n      \"name\": \"name\",\n      \"key\": \"key\"\n    }\n  ]\n}}
    end
  end

  describe "#parametes_hash" do
    context "when blank" do
      it "returns default" do
        message.parameters = ""
        expect(message.parameters_hash).to eq ({ "parameters" => [] })
      end
    end

    context "when nil" do
      it "returns default" do
        message.parameters = nil
        expect(message.parameters_hash).to eq ({ "parameters" => [] })
      end
    end

    it "returns hash representation" do
      message.parameters = parameters
      expect(message.parameters_hash).to eq parameters_hash
    end
  end

  describe "#payload=" do
    it "prettifies payload" do
      message.payload = %Q{{"key":"key","messages":[{"key":"key"}]}}
      expect(message.payload).to eq %Q{{\n  "key": "key",\n  "messages": [\n    {\n      "key": "key"\n    }\n  ],\n  "message_id": "1b"\n}}
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
    it "makes a request" do
      api_request.should_receive(:post).with token, uri, %Q{{"message":"test:test","message_id":"1a","parameters":[]}}
      message.send_request api_request
    end
  end
end

