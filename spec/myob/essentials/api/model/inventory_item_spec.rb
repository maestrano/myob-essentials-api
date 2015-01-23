require 'spec_helper'

describe Myob::Essentials::Api::Model::InventoryItem do

  let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:business_uid) { '168254' }
  let(:params) { {consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', business_uid: business_uid} }

  subject { Myob::Essentials::Api::Client.new(params) }
  
  describe ".inventory_item.all_items" do 
    let(:contacts_response) { File.read("spec/fixtures/businesses/#{business_uid}/inventory/items.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/inventory/items").to_return(:status => 200, :body => contacts_response, :headers => {}) }
    
    it "fetches the list of items" do
      expect(subject.inventory_item.all_items).to eql(JSON.parse(contacts_response)["items"])
    end
  end

  describe ".inventory_item.find" do 
    let(:item_uid) { '987816' }
    let(:item_response) { File.read("spec/fixtures/businesses/#{business_uid}/inventory/items/#{item_uid}.json") }

    before { stub_request(:get, "https://api.myob.com/au/essentials/businesses/#{business_uid}/inventory/items/#{item_uid}").to_return(:status => 200, :body => item_response, :headers => {}) }
    
    it "fetches an item by uid" do
      expect(subject.inventory_item.find(item_uid)).to eql(JSON.parse(item_response))
    end
  end

end
