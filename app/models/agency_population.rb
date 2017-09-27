class AgencyPopulation < ApplicationRecord
  belongs_to :arrest, foreign_key: 'agency_id'
end
