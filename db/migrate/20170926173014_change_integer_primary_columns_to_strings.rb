class ChangeIntegerPrimaryColumnsToStrings < ActiveRecord::Migration[5.1]
  def change
    change_column :hearing_court_names, :slc_id, :string, null: false
    change_column :judges, :slc_id, :string, null: false
  end
end
