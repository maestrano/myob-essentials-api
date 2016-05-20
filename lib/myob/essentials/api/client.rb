require 'base64'
require 'oauth2'

module Myob
  module Essentials
    module Api
      class Client
        include Myob::Essentials::Api::Helpers

        attr_reader :client, :access_token, :refresh_token, :expires_at, :endpoint
        attr_accessor :business_uid

        def initialize(options)
          model :Business
          model :TaxType
          model :AccountType
          model :AccountClassification
          model :Contact
          model :InventoryItem
          model :Account
          model :AccountBalance
          model :SaleInvoice
          model :SalePayment
          
          @redirect_uri         = options[:redirect_uri]
          @consumer             = options[:consumer]
          @access_token         = options[:access_token]
          @refresh_token        = options[:refresh_token]
          @auto_refresh         = options[:auto_refresh] || true
          @endpoint             = options[:endpoint] || 'au'
          @business_uid         = options[:business_uid]
          
          @client               = OAuth2::Client.new(@consumer[:key], @consumer[:secret], {
            site:          'https://secure.myob.com',
            authorize_url: '/oauth2/account/authorize',
            token_url:     '/oauth2/v1/authorize',
            connection_opts: {request: {timeout: options[:timeout] || 300}}
          })
        end

        def get_access_code_url(params = {})
          @client.auth_code.authorize_url(params.merge(scope: 'la.global', redirect_uri: @redirect_uri))
        end

        def get_access_token(access_code)
          @token         = @client.auth_code.get_token(access_code, redirect_uri: @redirect_uri)
          @access_token  = @token.token
          @expires_at    = @token.expires_at
          @refresh_token = @token.refresh_token
          @token
        end

        def headers
          {
            'x-myobapi-key'     => @consumer[:key],
            'x-myobapi-version' => 'v0',
            'Accept'            => 'application/json',
            'Content-Type'      => 'application/json'
          }
        end

        def refresh!
          @auth_connection ||= OAuth2::AccessToken.new(@client, @access_token, {refresh_token: @refresh_token})

          @token         = @auth_connection.refresh!
          @access_token  = @token.token
          @expires_at    = @token.expires_at
          @refresh_token = @token.refresh_token
          @token
        end

        def connection
          @auth_connection ||= begin
            if @refresh_token
              OAuth2::AccessToken.new(@client, @access_token, {refresh_token: @refresh_token})
            else
              OAuth2::AccessToken.new(@client, @access_token)
            end
          end
          refresh! if @auto_refresh && @expires_at && @expires_at < Time.now.to_i
          @auth_connection
        end

      end
    end
  end
end
