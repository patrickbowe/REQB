class HelpRequest < ActiveRecord::Base
  validates_presence_of :sender_email,:email_content
  belongs_to :user
  belongs_to :member
  validates_presence_of :sender_email,:email_content 
end
