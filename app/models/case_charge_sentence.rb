class CaseChargeSentence < ApplicationRecord
  belongs_to :charge, class_name: 'CaseCharge', foreign_key: 'charge_pk'
end
