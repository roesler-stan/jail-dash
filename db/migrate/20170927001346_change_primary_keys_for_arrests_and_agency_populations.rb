class ChangePrimaryKeysForArrestsAndAgencyPopulations < ActiveRecord::Migration[5.1]
  def change
    remove_column :agency_populations, :slc_id
    change_column :agency_populations, :agency_id, :string, null: false
    add_index :agency_populations, :agency_id, unique: true
  end
end
