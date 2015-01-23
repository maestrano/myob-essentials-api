require 'spec_helper'

describe Myob::Essentials::Api::Model::Base do

	let(:consumer) { {key: 'key', secret: 'secret'} }
  let(:params) { {redirect_uri: 'redirect_uri', consumer: consumer, access_token: 'access_token', refresh_token: 'refresh_token'} }
	let(:client) { Myob::Essentials::Api::Client.new(params) }

	subject { Myob::Essentials::Api::Model::Base.new(client, 'base') }
	
	describe ".save" do 
		let(:base_hash) { {'key' => 'value'} }

		context 'create a new object' do
			before { stub_request(:post, "https://api.myob.com/au/essentials/base")
        .with(:body => base_hash.to_json, :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(:status => 200, :body => {}.to_json, :headers => {})
      }

			it "posts the object" do
				subject.save(base_hash)
			end
		end

		context 'update an existing object' do
			let(:uid) { '892341' }
			before { base_hash['uid'] = uid }
			before { stub_request(:put, "https://api.myob.com/au/essentials/base/#{uid}")
        .with(:body => base_hash.to_json, :headers => {'Accept'=>'application/json', 'Content-Type'=>'application/json'})
        .to_return(:status => 200, :body => {}.to_json, :headers => {})
      }
			
			it "puts the object" do
				subject.save(base_hash)
			end
		end
	end

end
