module Myob
  module Essentials
    module Api
      module Model
        class TaxType < Base
          def model_route
            'tax/types'
          end
        end
      end
    end
  end
end
