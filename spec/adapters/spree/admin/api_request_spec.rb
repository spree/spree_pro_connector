# encoding: utf-8

require "spec_helper"
require "httparty"

describe Spree::Admin::ApiRequest do
  let(:token)       { "maggie" }
  let(:uri)         { "localhost" }
  let(:payload)     { "homer" }
  let(:response)    { "bart" }
  let(:headers)     { { "X-Augury-Token" => token } }

  describe "#self.post" do
    it "makes a post" do
      HTTParty.stub(:post).with(uri, body: payload, headers: headers).and_return response
      expect(described_class.post token, uri, payload).to eq response
    end
  end
end

