class Arrest < ApplicationRecord
  self.primary_key = 'slc_id'

  has_many :bookings, foreign_key: 'arrest'
end
