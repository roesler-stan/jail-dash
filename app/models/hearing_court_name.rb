class HearingCourtName < ApplicationRecord
  self.primary_key = 'slc_id'

  has_many :cases, class_name: 'CaseMaster', foreign_key: 'jurisdiction_code'
end
