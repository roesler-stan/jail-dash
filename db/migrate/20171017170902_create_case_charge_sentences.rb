class CreateCaseChargeSentences < ActiveRecord::Migration[5.1]
  def change
    create_table :case_charge_sentences do |t|
      t.integer :max_days
      t.bigint :charge_pk

      t.index :charge_pk
    end
  end
end
