class CreateAlternateFlows < ActiveRecord::Migration
  def self.up
    create_table :alternate_flows do |t|
      t.text :title
      t.references :basic_flow
      t.timestamps
    end
  end

  def self.down
    drop_table :alternate_flows
  end
end
