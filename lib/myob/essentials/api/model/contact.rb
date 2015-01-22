module Myob
  module Essentials
    module Api
      module Model
        class Contact < Base
          def model_route
            'businesses/:business_uid/contacts'
          end
        end
      end
    end
  end
end
