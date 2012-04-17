class Project < ActiveRecord::Base

  belongs_to :user
  belongs_to :member
  has_many :requirements, :dependent=>:destroy
  has_many :use_cases, :dependent=>:destroy
  has_many :trackers, :dependent=>:destroy
  has_many :definitions, :dependent=>:destroy
  has_many :project_files, :dependent=>:destroy
  has_many :categories, :dependent=>:destroy
  has_many :delivery_periods, :dependent=>:destroy
  #validates_presence_of :project_name
  validates_uniqueness_of  :project_name,:scope => [:user_id]
  has_one :attribute, :dependent=>:destroy
  has_many :notifications,:dependent=>:destroy
  #validates_presence_of :description

  def self.assign_project_id(user_id)
      project=Project.find(:all,:conditions=>["user_id=?",user_id])
  end

  def find_actor(project)
    use=project.use_cases.find :all
    actors=Array.new
    use.each do |u|
      actor=u.actors.find :all
      if !actor.nil?
        actor.each do |a|
          actors << a
        end
      end  
    end
    return actors
  end


  def self.create_notification(project_id,user_id)
     all_members=Member.find(:all,:conditions=>["user_id=?",user_id])
     user=User.find(user_id)
     user.notifications.create(:user_id=>user_id,:project_id=>project_id)
     all_members.each do |member|
       if member.active==true
         member.notifications.create(:user_id=>user_id,:member_id=>member.id,:project_id=>project_id)
       end  
     end

  end
end
