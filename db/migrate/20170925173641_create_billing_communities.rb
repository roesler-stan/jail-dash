class CreateBillingCommunities < ActiveRecord::Migration[5.1]
  def change
    create_table :billing_communities do |t|
      t.bigint :id_guid
      t.string :extdesc

      t.index :id_guid, unique: true
    end
  end
end
