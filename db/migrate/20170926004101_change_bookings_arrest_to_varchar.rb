class ChangeBookingsArrestToVarchar < ActiveRecord::Migration[5.1]
  def change
    # must remove index before altering column
    remove_index :bookings, :arrest
    change_column :bookings, :arrest, :string
    add_index :bookings, :arrest
  end
end
