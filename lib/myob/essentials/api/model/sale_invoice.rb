module Myob
  module Essentials
    module Api
      module Model
        class SaleInvoice < Base
          def model_route
            'businesses/:business_uid/sale/invoices'
          end
        end
      end
    end
  end
end
