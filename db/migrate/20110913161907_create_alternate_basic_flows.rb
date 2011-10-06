class CreateAlternateBasicFlows < ActiveRecord::Migration
  def self.up
    create_table :alternate_basic_flows do |t|
      t.text :action
      t.text :response
      t.references :alternate_flow
      t.integer :seq_number
      t.timestamps
    end
  end

  def self.down
    drop_table :alternate_basic_flows
  end
end
