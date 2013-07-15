require "spec_helper"

describe SpreeProConnector::URLUtil do
  subject { SpreeProConnector::URLUtil }

  describe ".ensure_http_preffix" do
    it "appends http" do
      url = "0.0.0.0"
      expect(subject.ensure_http_preffix(url)).to eq "http://0.0.0.0"
    end

    it "keeps http" do
      url = "http://0.0.0.0"
      expect(subject.ensure_http_preffix(url)).to eq "http://0.0.0.0"
    end

    it "keeps https" do
      url = "https://0.0.0.0"
      expect(subject.ensure_http_preffix(url)).to eq "https://0.0.0.0"
    end

    it "ignores empty" do
      url = ""
      expect(subject.ensure_http_preffix(url)).to be_empty
    end

    it "ignores nil" do
      url = nil
      expect(subject.ensure_http_preffix(url)).to be_nil
    end
  end
end
