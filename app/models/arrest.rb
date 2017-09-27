class Arrest < ApplicationRecord
  self.primary_key = 'slc_id'

  belongs_to :agency, class_name: 'Arrest', foreign_key: 'agency_id'
end
