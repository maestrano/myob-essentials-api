module Myob
  module Essentials
    module Api
      module Model
        class InventoryItem < Base
          def model_route
            'businesses/:business_uid/inventory/items'
          end
        end
      end
    end
  end
end
