require 'spec_helper'

describe SpreeProConnector::Preloader do
  subject { SpreeProConnector::Preloader.new('http://augury.dev', 'store', 'token') }
  it 'gets keys' do
    VCR.use_cassette('spree_pro_connector.preloader.keys') do
      response = subject.keys
      response.should match /order:updated/
    end
  end

  it 'gets integrations' do
    VCR.use_cassette('spree_pro_connector.preloader.integrations') do
      response = subject.integrations
      response.should match /{\"id\"\:\"store\"\,\"name\"\:\"Mandrill\"/
    end
  end

  it 'gets registrations' do
    VCR.use_cassette('spree_pro_connector.preloader.registrations') do
      response = subject.registrations
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
