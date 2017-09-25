class AddUniqueConstraintsToPKs < ActiveRecord::Migration[5.1]
  def change
    # indices must be removed from columns before they can be altered
    remove_index :arrests, :slc_id
    change_column_null :arrests, :slc_id, false
    add_index :arrests, :slc_id, unique: true
    
    remove_index :billing_communities, :id_guid
    change_column_null :billing_communities, :id_guid, false
    add_index :billing_communities, :id_guid, unique: true
    
    remove_index :bond_masters, :bondid
    change_column_null :bond_masters, :bondid, false
    add_index :bond_masters, :bondid, unique: true
    
    change_column :bookings, :sysid, :bigint, null: false
    remove_index :bookings, :sysid
    add_index :bookings, :sysid, unique: true
    
    change_column :case_charges, :charge_pk, :bigint, null: false
    remove_index :case_charges, :charge_pk
    add_index :case_charges, :charge_pk, unique: true
    
    change_column :case_masters, :case_pk, :bigint, null: false
    remove_index :case_masters, :case_pk
    add_index :case_masters, :case_pk, unique: true
    
    change_column :hearing_court_names, :slc_id, :bigint, null: false
    remove_index :hearing_court_names, :slc_id
    add_index :hearing_court_names, :slc_id, unique: true
    
    change_column :judges, :slc_id, :bigint, null: false
    remove_index :judges, :slc_id
    add_index :judges, :slc_id, unique: true
  end
end
