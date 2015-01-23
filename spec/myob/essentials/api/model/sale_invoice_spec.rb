require 'spec_helper'

describe Myob::Essentials::Api::Model::SaleInvoice do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:business_uid) { '168254' }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', business_uid: business_uid} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".sale_invoice.all_items" do 
    let(:contacts_response) { File.read("spec/fixtures/businesses/#{business_uid}/sale/invoices.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/sale/invoices").to_return(:status => 200, :body => contacts_response, :headers => {}) }
    
    it "fetches the list of sale invoices" do
      expect(subject.sale_invoice.all_items).to eql(JSON.parse(contacts_response)["items"])
    end
  end

  describe ".sale_invoice.find" do 
    let(:invoice_uid) { '35608735' }
    let(:invoice_response) { File.read("spec/fixtures/businesses/#{business_uid}/sale/invoices/#{invoice_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/sale/invoices/#{invoice_uid}").to_return(:status => 200, :body => invoice_response, :headers => {}) }
    
    it "fetches a sale invoice by uid" do
      expect(subject.sale_invoice.find(invoice_uid)).to eql(JSON.parse(invoice_response))
    end
  end

end
