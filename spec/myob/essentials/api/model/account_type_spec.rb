require 'spec_helper'

describe Myob::Essentials::Api::Model::AccountType do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token'} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".account_type.all_items" do 
    let(:tax_types_response) { File.read('spec/fixtures/account/types.json') }

    before { stub_request(:get, "https://api.myob.com/au/essentials/account/types").to_return(:status => 200, :body => tax_types_response, :headers => {}) }
    
    it "fetches the list of account types" do
      expect(subject.account_type.all_items).to eql(JSON.parse(tax_types_response)["items"])
    end
  end

  describe ".account_type.find" do 
    let(:tax_type_uid)  { '1' }
    let(:tax_type_response) { File.read("spec/fixtures/account/types/#{tax_type_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/account/types/#{tax_type_uid}").to_return(:status => 200, :body => tax_type_response, :headers => {}) }
    
    it "fetches an account type by uid" do
      expect(subject.account_type.find(tax_type_uid)).to eql(JSON.parse(tax_type_response))
    end
  end

end
