class CreateHearingCourtNames < ActiveRecord::Migration[5.1]
  def change
    create_table :hearing_court_names do |t|
      t.bigint :slc_id
      t.string :extdesc

      t.index :slc_id
    end
  end
end
