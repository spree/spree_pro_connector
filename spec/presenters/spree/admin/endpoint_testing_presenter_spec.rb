require "spec_helper"

describe Spree::Admin::EndpointTestingPresenter do
  subject(:presenter) { described_class.new message }
  let(:message)       { double "Message" }
  let(:messages)      { [message] }

  describe "#each_header" do
    before do
      message.stub response_headers: { "Content-Type" => "text/html; charset=utf-8", "Content-Length" => "3" }
    end

    it "yields each key" do
      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        ["Content-Type",   "text/html; charset=utf-8"],
        ["Content-Length", "3"]
      )
    end

    it "joins arrays" do
      message.stub response_headers: { "Content-Type" => ["text/html; charset=utf-8", "key2", "key3"] }

      expect{ |b| presenter.each_response_data &b }.to yield_successive_args(
        ["Content-Type", "text/html; charset=utf-8, key2, key3"]
      )
    end
  end

  describe "#response_json?" do
    it "returns true" do
      message.stub response_headers: { "Content-Type" => "application/json; charset=utf-8" }
      expect(presenter.response_json?).to be
    end

    context "when invalid" do
      it "returns false" do
        message.stub response_headers: { "content-type" => "text/html; charset=utf-8" }
        expect(presenter.response_json?).to_not be
      end
    end

    context "when nil" do
      it "returns false" do
        message.stub response_headers: {}
        expect(presenter.response_json?).to_not be
      end
    end
  end

  describe "#response_json" do
    it "prettifies json" do
      json = { status: "ok" }.to_json
      message.stub response_body: json
      expect(presenter.response_json).to eq %Q{{\n  "status": "ok"\n}}
    end
  end

  describe "#response_html_safe" do
    it "escapes script tag" do
      message.stub response_body: "<script>alert('Hello');</script>"
      expect(presenter.response_html_safe).to eq "<xcriptx>alert('Hello');</xcriptx>"
    end
  end
end

