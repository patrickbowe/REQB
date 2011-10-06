class CreateBusinessRules < ActiveRecord::Migration
  def self.up
    create_table :business_rules do |t|
      t.text :title
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :business_rules
  end
end
