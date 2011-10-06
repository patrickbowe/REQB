class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :first_name
      t.string :last_name
      t.text   :billing_address
      t.string :city
      t.integer :zip
      t.string :region
      t.string :country
      t.string :phone
      t.references :user
      t.boolean :newsletter,:default=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :addresses
  end
end
