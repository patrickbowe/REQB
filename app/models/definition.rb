class Definition < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  belongs_to :project
end
