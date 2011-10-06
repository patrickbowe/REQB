class CreateBasicFlows < ActiveRecord::Migration
  def self.up
    create_table :basic_flows do |t|
      t.text :action
      t.text :response
      t.references :use_case
      t.integer :seq_number
      t.timestamps
    end
  end

  def self.down
    drop_table :basic_flows
  end
end
