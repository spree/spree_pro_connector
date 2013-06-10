# encoding: utf-8

require "spec_helper"
require "httparty"

describe Spree::Admin::ApiRequest do
  subject(:request) { described_class.new token }
  let(:token)       { "maggie" }
  let(:uri)         { "localhost" }
  let(:payload)     { "homer" }
  let(:response)    { "bart" }
  let(:headers)     { { "X-Augury-Token" => token } }

  describe "#post" do
    it "should make a post" do
      HTTParty.stub(:post).with(uri, body: payload, headers: headers).and_return response
      expect(request.post uri, payload).to eq response
    end
  end
end

