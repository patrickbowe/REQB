class CreateHelpRequests < ActiveRecord::Migration
  def self.up
    create_table :help_requests do |t|
      t.string :sender_email
      t.text   :email_content
      t.references :user
      t.references :member

      t.timestamps
    end
  end

  def self.down
    drop_table :help_requests
  end
end
