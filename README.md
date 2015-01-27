myob-essentials-api
===============

[![Build Status](https://secure.travis-ci.org/BrunoChauvet/myob-essentials-api.png?branch=master)](http://travis-ci.org/BrunoChauvet/myob-essentials-api)

## MYOB Essentials Accounting

Integrate with [![MYOB Essentials Accounting](http://developer.myob.com/api/essentials-accounting/)]

## Installation

Add this line to your application's Gemfile:

`gem 'myob-essentials-api'`

And then execute:

`bundle`

Or install it yourself as:

`gem install myob-essentials-api`

## Usage

### OAuth Authentication

If you've already got an OAuth access token, feel free to skip to API Client Setup.

The MYOB API uses 3 legged OAuth2. If you don't want to roll your own, or use the [OmniAuth strategy](https://github.com/davidlumley/omniauth-myob) you can authenticate using the `get_access_code_url` and `get_access_token` methods that [ghiculescu](https://github.com/ghiculescu) has provided like so:


``` ruby
    class MYOBSessionController  
      def new
        redirect_to myob_client.get_access_code_url
      end

      def create
        @token         = myob_client.get_access_token(params[:code])
        @businesses    = myob_client.business.all_items
        # then show the user a view of their available businesses
      end

      def myob_client
        @api_client = Myob::Essentials::Api::Client.new({
          consumer: {
            key:    YOUR_CONSUMER_KEY,
            secret: YOUR_CONSUMER_SECRET,
          },
          redirect_uri: callback_create_url
        })
      end
    end
```

### API Client Setup

#### Create an api_client

``` ruby
    api_client = Myob::Essentials::Api::Client.new({
      consumer: {
        key:    YOUR_CONSUMER_KEY,
        secret: YOUR_CONSUMER_SECRET,
      },
      access_token: YOUR_OAUTH_ACCESS_TOKEN
    })
```

If you have a refresh token (the Myob API returns one by default) you can use that too:

``` ruby
    api_client = Myob::Essentials::Api::Client.new({
      consumer: {
        key:    YOUR_CONSUMER_KEY,
        secret: YOUR_CONSUMER_SECRET,
      },
      access_token:  YOUR_OAUTH_ACCESS_TOKEN,
      refresh_token: YOUR_OAUTH_REFRESH_TOKEN
    })
```

Or if you know which Business UID you want to access too:

``` ruby
    api_client = Myob::Essentials::Api::Client.new({
      consumer: {
        key:    YOUR_CONSUMER_KEY,
        secret: YOUR_CONSUMER_SECRET,
      },
      access_token:  YOUR_OAUTH_ACCESS_TOKEN,
      refresh_token: YOUR_OAUTH_REFRESH_TOKEN,
      business_uid:  BUSINESS_UID
    })
```

The available options when creating the MYOB Essentials API client are

* redirect_uri: URI to redirect the user to after OAuth authentication
* consumer: Hash containing your OAuth key and secret
* access_token: Previously fetched access token
* refresh_token: Previously fetched refresh token
* business_uid: Previously selected business uid
* auto_refresh: Automatically refresh the access_token if expired (default `true`)
* endpoint: `au` or `nz` (default `au` for https://api.myob.com/au/essentials)

#### Refresh access token

The OAuth access token can be refreshed at any time by calling
`client.refresh!`

### API Methods

#### get

Retrieves the first page of specified collection

```ruby
  contacts = api_client.contact.get
```

#### next_page / previous_page

Retrieves the next/previous page of specified collection. A call to `get` must have been performed first

```ruby
  contacts = api_client.contact.get
  next_contacts = api_client.contact.next_page
  previous_contacts = api_client.contact.previous_page
```

#### find

Retrieves a single element by uid

```ruby
  contact = api_client.contact.find('123')
```

#### save

Saves a resource. The resource is `created` if no `uid` is specified, otherwise it is `updated`

```ruby
  contact = api_client.contact.save({'uid' => '123', 'key' => 'value'})
```

#### all_items

Fetches the entire collection of elements

```ruby
  contact = api_client.contact.all_items
```

### API Resources

#### Businesses
Before using the majority of API methods you will need to have selected a Business UID. If you've already selected one when creating the client, feel free to ignore this.
```ruby
  businesses = api_client.business.all_items
  api_client.business_uid = businesses[0]['uid']
```

####  Account Classifications
`api_client.account_classification.get`

####  Account Types
`api_client.account_type.get`

####  Tax Types
`api_client.tax_type.get`

####  Contacts
`api_client.contact.get`

####  Accounts
`api_client.account.get`

####  Inventory Items
`api_client.inventory_item.get`

####  Sale Invoices
`api_client.sale_invoice.get`

####  Sale Payments
`api_client.sale_payment.get`
