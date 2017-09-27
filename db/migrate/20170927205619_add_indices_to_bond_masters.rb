class AddIndicesToBondMasters < ActiveRecord::Migration[5.1]
  def change
    add_index :bond_masters, :sysid
    add_index :bond_masters, :bondtype
    add_index :bond_masters, :case_pk
    add_index :case_masters, :judge
  end
end
