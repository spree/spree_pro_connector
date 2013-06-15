require "spec_helper"

describe Spree::Admin::EndpointTestingPresenter do
  subject(:presenter) { described_class.new message }
  let(:message)       { double "Message" }
  let(:messages)      { [message] }

  describe "#each_header" do
    before do
      message.stub uri: "http://127.0.0.1"
      message.stub response_code: "200"
      message.stub response_headers: { "Content-Type" => "text/html; charset=utf-8" }
      message.stub response_body: "ok"
    end

    it "should yield each key" do
      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        [:uri, "http://127.0.0.1"],
        [:code, "200"],
        ["Content-Type", "text/html; charset=utf-8"],
      )
    end

    it "should join arrays" do
      message.stub response_headers: { "Content-Type" => ["text/html; charset=utf-8"] }

      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        [:uri, "http://127.0.0.1"],
        [:code, "200"],
        ["Content-Type", "text/html; charset=utf-8"]
      )
    end
  end

  describe "#response_json?" do
    it "should return true" do
      message.stub response_headers: { "Content-Type" => "application/json; charset=utf-8" }
      expect(presenter.response_json?).to be
    end

    it "should return false" do
      message.stub response_headers: { "Content-Type" => "text/html; charset=utf-8" }

      expect(presenter.response_json?).to_not be
    end
  end

  describe "#response_json" do
    it "should return pretty json" do
      json = { status: "ok" }.to_json
      message.stub response_body: json
      expect(presenter.response_json).to eq "{\n  \"status\": \"ok\"\n}"
    end
  end

  describe "#response_html_safe" do
    it "should escape script tag" do
      message.stub response_body: "<script>alert('Hello');</script>"
      expect(presenter.response_html_safe).to eq "<xcriptx>alert('Hello');</xcriptx>"
    end
  end
end

