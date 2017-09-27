class Arrest < ApplicationRecord
  self.primary_key = 'slc_id'

  has_many :bookings, foreign_key: 'arrest'
  has_one :agency_population, foreign_key: 'agency_id'
end
