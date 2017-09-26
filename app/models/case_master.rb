class CaseMaster < ApplicationRecord
  self.primary_key = 'case_pk'

  has_many :charges, class_name: 'CaseCharge', foreign_key: 'charge_pk'
  belongs_to :judge, foreign_key: 'slc_id'
  belongs_to :billing_community, foreign_key: 'id_guid'
  belongs_to :booking, foreign_key: 'sysid'
  belongs_to :hearing_court_name, foreign_key: 'slc_id'
end
