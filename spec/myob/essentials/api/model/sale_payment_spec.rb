require 'spec_helper'

# http://developer.myob.com/api/essentials-accounting/endpoints/sale/payments/
# Endpoint not implemented yet
describe Myob::Essentials::Api::Model::SalePayment do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:business_uid) { '168254' }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', business_uid: business_uid} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".sale_payment.all_items" do 
    let(:contacts_response) { File.read("spec/fixtures/businesses/#{business_uid}/sale/payments.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/sale/payments").to_return(:status => 200, :body => contacts_response, :headers => {}) }
    
    it "fetches the list of sale payments" do
      expect(subject.sale_payment.all_items).to eql(JSON.parse(contacts_response)["items"])
    end
  end

  describe ".sale_payment.find" do 
    let(:payment_uid) { '987816' }
    let(:payment_response) { File.read("spec/fixtures/businesses/#{business_uid}/sale/payments/#{payment_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/sale/payments/#{payment_uid}").to_return(:status => 200, :body => payment_response, :headers => {}) }
    
    it "fetches a sale payment by uid" do
      expect(subject.sale_payment.find(payment_uid)).to eql(JSON.parse(payment_response))
    end
  end

end if false