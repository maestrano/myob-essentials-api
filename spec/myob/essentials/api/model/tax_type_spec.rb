require 'spec_helper'

describe Myob::Essentials::Api::Model::TaxType do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token'} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".tax_type.all_items" do 
    let(:tax_types_response) { File.read('spec/fixtures/tax/types.json') }

    before { stub_request(:get, "https://api.myob.com/au/essentials/tax/types").to_return(:status => 200, :body => tax_types_response, :headers => {}) }
    
    it "fetches the list of tax types" do
      expect(subject.tax_type.all_items).to eql(JSON.parse(tax_types_response)["items"])
    end
  end

  describe ".tax_type.find" do 
    let(:tax_type_uid)  { '5' }
    let(:tax_type_response) { File.read("spec/fixtures/tax/types/#{tax_type_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/tax/types/#{tax_type_uid}").to_return(:status => 200, :body => tax_type_response, :headers => {}) }
    
    it "fetches a tax type by uid" do
      expect(subject.tax_type.find(tax_type_uid)).to eql(JSON.parse(tax_type_response))
    end
  end

end
