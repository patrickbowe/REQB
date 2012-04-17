class NotificationMessage < ActiveRecord::Base
  belongs_to :user
  belongs_to :member

end
