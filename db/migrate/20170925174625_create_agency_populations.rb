class CreateAgencyPopulations < ActiveRecord::Migration[5.1]
  def change
    create_table :agency_populations do |t|
      t.bigint :slc_id
      t.bigint :agency_id
      t.integer :population
    end
  end
end
