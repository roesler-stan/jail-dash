class BondMaster < ApplicationRecord
  self.primary_key = 'bondid'

  belongs_to :booking, foreign_key: 'sysid'
  belongs_to :case, class_name: 'CaseMaster', foreign_key: 'case_pk'
end
