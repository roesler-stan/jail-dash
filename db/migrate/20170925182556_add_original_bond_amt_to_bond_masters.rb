class AddOriginalBondAmtToBondMasters < ActiveRecord::Migration[5.1]
  def change
    add_column :bond_masters, :original_bond_amt, :integer
  end
end
