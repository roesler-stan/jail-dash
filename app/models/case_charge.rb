class CaseCharge < ApplicationRecord
  self.primary_key = 'charge_pk'

  belongs_to :case, class_name: 'CaseMaster', foreign_key: 'case_pk'
  belongs_to :booking, foreign_key: 'sysid'
end
