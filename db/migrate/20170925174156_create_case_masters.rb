class CreateCaseMasters < ActiveRecord::Migration[5.1]
  def change
    create_table :case_masters do |t|
      t.bigint :case_pk
      t.string :jurisdiction_code
      t.string :judge
      t.bigint :billing_community
      t.bigint :sysid

      t.index :case_pk
      t.index :billing_community
      t.index :sysid
    end
  end
end
