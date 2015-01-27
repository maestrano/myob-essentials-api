module Myob
  module Essentials
    module Api
      module Model
        class AccountBalance < Base
          def model_route
            'businesses/:business_uid/generalledger/accounts/balances'
          end
        end
      end
    end
  end
end
