require "spec_helper"

describe Spree::Admin::EndpointTestingPresenter do
  subject(:presenter) { described_class.new(message, environment) }
  let(:message)       { double("Endpoint Message") }
  let(:messages)      { [ message ] }
  let(:environment)   { double("Environment", url: "", token: "", store_id: "") }


  describe "#each_parameter_hash_with_index" do
    it "yields each parameter_hash" do
      parameter_hash1 = { "name" => "param name", "value" => "param value" }
      parameters_hash = { "parameters" => [ parameter_hash1 ] }
      message.stub(parameters_hash: parameters_hash)
      expect{ |b| presenter.each_parameter_hash_with_index &b }.to yield_successive_args([ parameter_hash1, 0 ])
    end
  end

  describe "#available_services" do
    context "when environement is present" do
      let(:preloader)  { double("Preloader") }

      before do
        SpreeProConnector::Preloader.stub(new: preloader)
      end

      context "when environment is nil" do
        subject(:presenter) { described_class.new(message, nil) }
      end
    end
  end

  describe "#each_header" do
    before do
      message.stub(response_headers: { "Content-Type" => "text/html; charset=utf-8", "Content-Length" => "3" })
    end

    it "yields each key" do
      expect { |b| presenter.each_response_data &b }.to yield_successive_args(
        ["Content-Type",   "text/html; charset=utf-8"],
        ["Content-Length", "3"]
      )
    end

    it "joins arrays" do
      message.stub(response_headers: { "Content-Type" => ["text/html; charset=utf-8", "key2", "key3"] })

      expect { |b| presenter.each_response_data &b }.to yield_successive_args(
        ["Content-Type", "text/html; charset=utf-8, key2, key3"]
      )
    end
  end

  describe "#response_json?" do
    context "when is json" do
      it "returns true" do
        message.stub(response_headers: { "Content-Type" => "application/json; charset=utf-8" })

        expect(presenter.response_json?).to be
      end
    end

    context "when is not json" do
      it "returns false" do
        message.stub(response_headers: { "content-type" => "text/html; charset=utf-8" })

        expect(presenter.response_json?).to_not be
      end
    end

    context "when is content-type is unavailable" do
      it "returns false" do
        message.stub response_headers: {}

        expect(presenter.response_json?).to_not be
      end
    end
  end

  describe "#response_json" do
    it "prettifies json" do
      message.stub(response_body: %Q{{ "status": "ok" }})

      expect(presenter.response_json).to eq %Q{{\n  "status": "ok"\n}}
    end
  end

  describe "#response_html_safe" do
    it "escapes script tag" do
      message.stub response_body: "<script>alert('Hello');</script>"

      expect(presenter.response_html_safe).to eq "<xcriptx>alert('Hello');</xcriptx>"
    end
  end

  describe "#response_time" do
    it "rounds to 2" do
      message.stub response_time: 1.1234

      expect(presenter.response_time).to eq 1.12
    end

    context "when is nil" do
      it "returns 0.0" do
        message.stub response_time: nil

        expect(presenter.response_time).to eq 0.0
      end
    end
  end
end

