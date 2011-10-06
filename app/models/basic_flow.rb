class BasicFlow < ActiveRecord::Base
  belongs_to :use_case
  has_many :alternate_flows, :dependent=>:destroy
end
