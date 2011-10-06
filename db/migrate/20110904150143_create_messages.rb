class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.text :title
      t.text :content
      t.references :use_case
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
