class Notification < ActiveRecord::Base
  belongs_to :users
  belongs_to :members
  belongs_to :projects
end
