module Myob
  module Essentials
    module Api
      module Model
        class Account < Base
          def model_route
            'businesses/:business_uid/generalledger/accounts'
          end
        end
      end
    end
  end
end
