class CaseMaster < ApplicationRecord
  self.primary_key = 'case_pk'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'charge_pk'
  belongs_to :judge, foreign_key: 'judge'
  belongs_to :billing_community, foreign_key: 'billing_community'
  belongs_to :booking, foreign_key: 'sysid'
  belongs_to :hearing_court_name, foreign_key: 'jurisdiction_code'
end
