class Contact < ActiveRecord::Base
  validates_presence_of :email,:name,:reason,:query
end
