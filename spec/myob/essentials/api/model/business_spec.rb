require 'spec_helper'

describe Myob::Essentials::Api::Model::Business do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token'} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".business.all_items" do 
    let(:businesses_response) { File.read('spec/fixtures/businesses.json') }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses").to_return(:status => 200, :body => businesses_response, :headers => {}) }
    
    it "fetches the list of businesses" do
      expect(subject.business.all_items).to eql(JSON.parse(businesses_response)["items"])
    end
  end

  describe ".business.find" do 
    let(:business_uid)  { '168254' }
    let(:business_response) { File.read("spec/fixtures/businesses/#{business_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}").to_return(:status => 200, :body => business_response, :headers => {}) }
    
    it "fetches a business by uid" do
      expect(subject.business.find(business_uid)).to eql(JSON.parse(business_response))
    end
  end

end
