class BillingCommunity < ApplicationRecord
  self.primary_key = 'id_guid'

  has_many :cases, class_name: 'CaseMaster', foreign_key: 'billing_community'
end
