class ReplaceBondTypeColumn < ActiveRecord::Migration[5.1]
  def change
    remove_column :bond_masters, :bondtype

    add_column :bond_masters, :type_id, :string
    add_index :bond_masters, :type_id
  end
end
