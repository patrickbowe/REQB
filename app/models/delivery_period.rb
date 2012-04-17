class DeliveryPeriod < ActiveRecord::Base
  belongs_to :project
  validates_uniqueness_of :title, :scope => [:project_id]
end
