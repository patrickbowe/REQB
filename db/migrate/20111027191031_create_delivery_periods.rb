class CreateDeliveryPeriods < ActiveRecord::Migration
  def self.up
    create_table :delivery_periods do |t|
      t.text :title
      t.references :project
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :delivery_periods
  end
end
