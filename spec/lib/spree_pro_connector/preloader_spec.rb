require 'spec_helper'

describe SpreeProConnector::Preloader do
  subject { SpreeProConnector::Preloader.new('http://augury.dev', 'store', 'token') }
  it 'gets messages' do
    VCR.use_cassette('spree_pro_connector.preloader.messages') do
      response = subject.messages
      response.should match /order:updated/
    end
  end

  it 'gets mappings' do
    VCR.use_cassette('spree_pro_connector.preloader.mappings') do
      response = subject.mappings
      response.should match /{\"id\"\:\"store\",\"name\"\:/
    end
  end

  it 'gets parameters' do
    VCR.use_cassette('spree_pro_connector.preloader.parameters') do
      response = subject.parameters
      response.should match /{\"id\"\:\"store\",\"name\"\:\"mandrill/
    end
  end
end
