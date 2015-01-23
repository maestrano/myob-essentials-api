module Myob
  module Essentials
    module Api
      module Model
        class SalePayment < Base
          def model_route
            'businesses/:business_uid/sale/payments'
          end
        end
      end
    end
  end
end
