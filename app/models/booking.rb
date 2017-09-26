class Booking < ApplicationRecord
  self.primary_key = 'sysid'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'charge_pk'
  has_many :cases, class_name: 'CaseMaster', foreign_key: 'jurisdiction_code'
  belongs_to :arrest, foreign_key: 'slc_id'
end
