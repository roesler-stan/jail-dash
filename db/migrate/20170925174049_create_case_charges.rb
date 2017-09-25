class CreateCaseCharges < ActiveRecord::Migration[5.1]
  def change
    create_table :case_charges do |t|
      t.bigint :charge_pk
      t.bigint :case_pk
      t.bigint :sysid
      t.string :reason_for_discharge
      t.string :disposition
      t.datetime :disposition_date

      t.index :charge_pk
      t.index :case_pk
      t.index :sysid
    end
  end
end
