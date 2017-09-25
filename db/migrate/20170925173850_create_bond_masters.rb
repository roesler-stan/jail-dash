class CreateBondMasters < ActiveRecord::Migration[5.1]
  def change
    create_table :bond_masters do |t|
      t.bigint :bondid
      t.bigint :sysid
      t.string :bondtype
      t.bigint :case_pk

      t.index :bondid, unique: true
    end
  end
end
