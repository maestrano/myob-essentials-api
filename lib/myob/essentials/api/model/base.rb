module Myob
  module Essentials
    module Api
      module Model
        class Base

          def initialize(client, model_name=nil)
            @client          = client
            @model_name      = model_name || 'Base'
            
            @links = nil
          end

          def model_route
            @model_name.to_s.downcase
          end

          def get(params = {})
            perform_request(url(nil, params))
          end

          def find(id)
            object = { 'uid' => id }
            perform_request(url(object))
          end

          def save(object)
            new_record?(object) ? create(object) : update(object)
          end

          def destroy(object)
            @client.connection.delete(url(object), :headers => @client.headers)
          end

          def all_items(params = {})
            results = get(params)["items"]
            while link('next')
              results += next_page["items"] || []
            end
            results
          end
          
          def next_page
            perform_request(link('next')) if link('next')
          end

          def previous_page
            perform_request(link('previous')) if link('previous')
          end

protected
          def url(object = nil, params = {})
            if model_route == ''
              "https://api.myob.com/#{@client.endpoint}/essentials"
            elsif object && object['uid']
              "#{resource_url}/#{object['uid']}"
            else
              "#{resource_url}?#{URI.encode_www_form(params)}"
            end
          end

          def new_record?(object)
            object["uid"].nil? || object["uid"] == ""
          end

          def create(object)
            object = typecast(object)
            @client.connection.post(url, {:headers => @client.headers, :body => object.to_json})
          end

          def update(object)
            object = typecast(object)
            @client.connection.put(url(object), {:headers => @client.headers, :body => object.to_json})
          end

          def typecast(object)
            returned_object = object.dup # don't change the original object

            returned_object.each do |key, value|
              if value.respond_to?(:strftime)
                returned_object[key] = value.strftime(date_formatter)
              end
            end

            returned_object
          end

          def link(name)
            return nil unless @links
            link_hash = @links.select{|link_hash| link_hash['rel'] == name}.first
            link_hash ? link_hash['href'] : nil
          end

          def date_formatter
            "%Y-%m-%dT%H:%M:%S"
          end
          
          def resource_url
            url = "https://api.myob.com/#{@client.endpoint}/essentials/#{model_route}"
            url.gsub!(':business_uid', @client.business_uid) if @client.business_uid
            url
          end
          
          def perform_request(url)
            response = @client.connection.get(url, {:headers => @client.headers})
            hash = JSON.parse(response.body)
            @links = hash['_links']
            hash
          end
        end
      end
    end
  end
end
