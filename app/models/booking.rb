class Booking < ApplicationRecord
  self.primary_key = 'sysid'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'sysid'
  has_many :cases, class_name: 'CaseMaster', foreign_key: 'sysid'
  belongs_to :arrest, foreign_key: 'arrest'
end
