require "spec_helper"
require "httparty"

describe Spree::Admin::ApiRequest do
  let(:token)         { "maggie" }
  let(:uri)           { "localhost" }
  let(:payload)       { "homer" }
  let(:headers)       { { "X-Augury-Token" => token } }
  let(:code)          { 200 }
  let(:body)          { "bart" }
  let(:response_hash) { { code: code, headers: headers, body: body, response_time: 0.0 } }
  let(:response)      { double "HTTP response", response_hash }

  describe ".post" do
    it "makes a post" do
      frozen_time = Time.now
      Time.stub now: frozen_time
      HTTParty.stub(:post).with(uri, body: payload, headers: headers).and_return response
      expect(described_class.post token, uri, payload).to eq response_hash
    end
  end
end

