class Project < ActiveRecord::Base

  belongs_to :user
  belongs_to :member
  has_many :requirements, :dependent=>:destroy
  has_many :use_cases, :dependent=>:destroy
  has_many :trackers, :dependent=>:destroy
  has_many :definitions, :dependent=>:destroy
  has_many :project_files, :dependent=>:destroy
  #validates_presence_of :project_name
  validates_uniqueness_of  :project_name

  #validates_presence_of :description

  def self.assign_project_id(user_id)
      project=Project.find(:all,:conditions=>["user_id=?",user_id])
  end

  
end
