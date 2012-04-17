class Address < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :subscription_url

end
