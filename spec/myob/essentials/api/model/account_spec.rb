require 'spec_helper'

describe Myob::Essentials::Api::Model::Account do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:business_uid) { '168254' }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', business_uid: business_uid} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".account.all_items" do 
    let(:accounts_response) { File.read("spec/fixtures/businesses/#{business_uid}/generalledger/accounts.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/generalledger/accounts").to_return(:status => 200, :body => accounts_response, :headers => {}) }
    
    it "fetches the list of accounts" do
      expect(subject.account.all_items).to eql(JSON.parse(accounts_response)["items"])
    end
  end

  describe ".account.find" do 
    let(:account_uid) { '10108109' }
    let(:account_response) { File.read("spec/fixtures/businesses/#{business_uid}/generalledger/accounts/#{account_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/generalledger/accounts/#{account_uid}").to_return(:status => 200, :body => account_response, :headers => {}) }
    it "fetches an account by uid" do
      expect(subject.account.find(account_uid)).to eql(JSON.parse(account_response))
    end
  end

end
