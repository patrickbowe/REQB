class CreateAttributes < ActiveRecord::Migration
  def self.up
    create_table :attributes do |t|
      t.boolean :req_status,:default=> true
      t.boolean :req_priority,:default=> true
      t.boolean :req_importance,:default=> true
      t.boolean :req_category,:default=> true
      t.boolean :req_type,:default=> true
      t.boolean :req_verification,:default=> true
      t.boolean :req_delivered,:default=> true
      t.boolean :use_status,:default=> true
      t.boolean :use_priority,:default=> true
      t.boolean :use_importance,:default=> true
      t.boolean :use_category,:default=> true
      t.boolean :use_goal,:default=> true
      t.boolean :use_delivered,:default=> true
      t.references :project
      t.references :user
      t.references :member
      t.timestamps
    end
  end

  def self.down
    drop_table :attributes
  end
end
