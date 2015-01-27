require 'spec_helper'

describe Myob::Essentials::Api::Model::Base do

	let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:endpoint) { 'au' }
  let(:params) { {redirect_uri: 'redirect_uri', consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token', endpoint: endpoint} }
	let(:client) { Myob::Essentials::Api::Client.new(params) }

	subject { Myob::Essentials::Api::Model::Base.new(client, 'base') }
	
	describe ".get" do 
    let(:response_hash) { {'key' => 'value'} }

    context 'AU endpoint' do
      let(:endpoint) { 'au' }
      before { stub_request(:get, "https://api.myob.com/au/essentials/base").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => response_hash.to_json, :headers => {}) }

      it "gets all the objects from AU endpoint" do
        expect(subject.get).to eql(response_hash)
      end
    end

    context 'NZ endpoint' do
      let(:endpoint) { 'nz' }
      before { stub_request(:get, "https://api.myob.com/nz/essentials/base").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => response_hash.to_json, :headers => {}) }

      it "gets all the objects from NZ endpoint" do
        expect(subject.get).to eql(response_hash)
      end
    end
  end

  describe ".find" do 
    let(:response_hash) { {'key' => 'value'} }

    before { stub_request(:get, "https://api.myob.com/au/essentials/base/1").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => response_hash.to_json, :headers => {}) }

    it "gets the object" do
      expect(subject.find('1')).to eql(response_hash)
    end
  end

  describe ".save" do 
    let(:base_hash) { {'key' => 'value'} }

    context 'create a new object' do
      before { stub_request(:post, "https://api.myob.com/au/essentials/base")
        .with(:body => base_hash.to_json, :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(:status => 200, :body => {}.to_json, :headers => {}) }

      it "posts the object" do
        subject.save(base_hash)
      end
    end

    context 'update an existing object' do
      let(:uid) { '892341' }
      
      before { base_hash['uid'] = uid }
      before { stub_request(:put, "https://api.myob.com/au/essentials/base/#{uid}")
        .with(:body => base_hash.to_json, :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(:status => 200, :body => {}.to_json, :headers => {}) }
      
      it "puts the object" do
        subject.save(base_hash)
      end
    end
  end

  describe ".all_items" do 
    let(:page1) { File.read('spec/fixtures/base1.json') }
    let(:page2) { File.read('spec/fixtures/base2.json') }
    let(:page3) { File.read('spec/fixtures/base3.json') }

    before do
      stub_request(:get, "https://api.myob.com/au/essentials/base").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => page1, :headers => {})
      stub_request(:get, "https://api.myob.com/au/essentials/base?page=2&size=2").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => page2, :headers => {})
      stub_request(:get, "https://api.myob.com/au/essentials/base?page=3&size=2").with(:headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
              .to_return(:status => 200, :body => page3, :headers => {})
    end


    it "fetches all the paginated objects" do
      expect(subject.all_items).to eql([
        {"uid"=>"1", "_links"=>[{"rel"=>"self", "href"=>"https://api.myob.com/au/essentials/base/1"}]},
        {"uid"=>"2", "_links"=>[{"rel"=>"self", "href"=>"https://api.myob.com/au/essentials/base/2"}]},
        {"uid"=>"3", "_links"=>[{"rel"=>"self", "href"=>"https://api.myob.com/au/essentials/base/3"}]},
        {"uid"=>"4", "_links"=>[{"rel"=>"self", "href"=>"https://api.myob.com/au/essentials/base/4"}]},
        {"uid"=>"5", "_links"=>[{"rel"=>"self", "href"=>"https://api.myob.com/au/essentials/base/5"}]}
      ])
    end
  end

end
