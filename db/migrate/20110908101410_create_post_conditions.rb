class CreatePostConditions < ActiveRecord::Migration
  def self.up
    create_table :post_conditions do |t|
      t.text :title
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :post_conditions
  end
end
