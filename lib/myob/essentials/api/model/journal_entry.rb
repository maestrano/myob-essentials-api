module Myob
  module Essentials
    module Api
      module Model
        class JournalEntry < Base
          def model_route
            'businesses/:business_uid/generalledger/journalentries'
          end
        end
      end
    end
  end
end
