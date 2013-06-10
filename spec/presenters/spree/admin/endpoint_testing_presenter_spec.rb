require "spec_helper"

describe Spree::Admin::EndpointTestingPresenter do
  subject(:presenter) { described_class.new message }
  let(:message)       { double "Message" }
  let(:messages)      { [message] }

  describe "#samples" do
    it "should return the samples"
  end

  describe "#each_header" do
    before do
      message.stub uri: "http://127.0.0.1"
      message.stub response_code: "200"
      message.stub response_headers: { "content-type" => "text/html; charset=utf-8" }
      message.stub response_body: "ok"
    end

    it "should yield each key" do
      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        [:uri, "http://127.0.0.1"],
        [:code, "200"],
        ["content-type", "text/html; charset=utf-8"],
        [:body, "ok"]
      )
    end

    it "should join arrays" do
      message.stub response_headers: { "content-type" => ["text/html; charset=utf-8"] }

      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        [:uri, "http://127.0.0.1"],
        [:code, "200"],
        ["content-type", "text/html; charset=utf-8"],
        [:body, "ok"]
      )
    end
  end
end

