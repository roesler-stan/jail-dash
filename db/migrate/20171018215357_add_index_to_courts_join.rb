class AddIndexToCourtsJoin < ActiveRecord::Migration[5.1]
  def change
    add_index :case_masters, :jurisdiction_code
  end
end
