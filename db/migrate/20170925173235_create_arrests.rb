class CreateArrests < ActiveRecord::Migration[5.1]
  def change
    create_table :arrests do |t|
      t.string :slc_id, unique: true
      t.string :extdesc

      t.index :slc_id, unique: true
    end
  end
end
