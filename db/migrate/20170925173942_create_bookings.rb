class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.bigint :arrest
      t.datetime :comdate
      t.bigint :sysid
      t.datetime :reldate
      t.string :jlocat

      t.index :arrest
      t.index :sysid
      t.index :comdate
      t.index :reldate
    end
  end
end
