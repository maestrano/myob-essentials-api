require 'spec_helper'

describe Myob::Essentials::Api::Model::Contact do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:business_uid) { '168254' }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', business_uid: business_uid} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".contact.all_items" do 
    let(:contacts_response) { File.read("spec/fixtures/businesses/#{business_uid}/contacts.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/contacts").to_return(:status => 200, :body => contacts_response, :headers => {}) }
    
    it "fetches the list of contacts" do
      expect(subject.contact.all_items).to eql(JSON.parse(contacts_response)["items"])
    end
  end

  describe ".contact.find" do 
    let(:contact_uid) { '3604150' }
    let(:contact_response) { File.read("spec/fixtures/businesses/#{business_uid}/contacts/#{contact_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/contacts/#{contact_uid}").to_return(:status => 200, :body => contact_response, :headers => {}) }
    
    it "fetches a contact by uid" do
      expect(subject.contact.find(contact_uid)).to eql(JSON.parse(contact_response))
    end
  end

end
