class Tracker < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  belongs_to :member
  has_and_belongs_to_many :requirements
  has_and_belongs_to_many :use_cases
  has_and_belongs_to_many :project_files
  has_many :comments
  validates_uniqueness_of :title, :scope => [:project_id]
  
  def find_user_name
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address[0].nil?
     first_name=address[0].first_name.capitalize
    else
     address=Member.find(:all,:conditions=>["id=?",self.user_id])
     first_name=address[0].first_name.capitalize
     

    end

  end

  def self.find_all_user(user1)
    user=User.find(:all,:select=>"addresses.first_name,users.id",:joins=>"JOIN addresses on users.id=addresses.user_id",:conditions=>["users.id=? ",user1.id])
    member=Member.find(:all,:select=>"first_name,id",:conditions=>["user_id=? and first_name IS NOT ?",user1.id,nil])
    return user.concat(member)
  end

  def self.find_all_user1(user1)
      user=User.find(:all,:select=>"addresses.first_name,users.id",:joins=>"JOIN addresses on users.id=addresses.user_id",:conditions=>["users.id=?",user1.user_id])
      member=Member.find(:all,:select=>"first_name,id",:conditions=>["user_id=? and first_name IS NOT ?",user1.user_id,nil])
      return user.concat(member)
    end

  def self.find_tracker(project_id)
    tracker1=Tracker.find(:all,:conditions=>["project_id=? and flag_tracker=?",project_id,true],:order => "due")
    tracker2=Tracker.find(:all,:conditions=>["project_id=? and flag_tracker!=?",project_id,true],:order => "due")

    return tracker2.concat(tracker1)
  end

  def self.my_tracker(subscriber_id,first_name,project_id)
    tracker1=Tracker.find(:all,:conditions=>["assigned_subscriber_id=? and assigned ILIKE ? and project_id=? and flag_tracker=? ",subscriber_id,first_name,project_id,true],:order=>"due desc")
    tracker2=Tracker.find(:all,:conditions=>["assigned_subscriber_id=? and assigned ILIKE ? and project_id=? and flag_tracker!=? ",subscriber_id,first_name,project_id,true],:order=>"due desc")
    return tracker2.concat(tracker1)
  end
    def self.find_tracker_by_req(req)
    tracker1=req.trackers.find(:all,:conditions=>["flag_tracker=?",true])
    tracker2=req.trackers.find(:all,:conditions=>["flag_tracker!=?",true],:order => "created_at desc")

    return tracker2.concat(tracker1)
    end

  def self.check_attached_tracker_items(id)
     tracker=Tracker.find(id)
     comments=tracker.comments.find :all
     req=Tracker.find(:all,:conditions=>["requirement_id=?",nil])
     use=Tracker.find(:all,:conditions=>["use_case_id=?",nil])
     flag="false"
     if comments.empty? and req.empty? and use.empty?
       flag="true"
     end
     return flag

  end

  def self.find_link_req_tracker(req,tracker)
    req_tracker=tracker.requirements.include?(req)

  end

  def self.insert_req_tracker(req,tracker)
     tracker.requirements << req
  end

  def self.find_link_use_tracker(use,tracker)
    use_tracker=tracker.use_cases.include?(use)

  end

  def self.insert_use_tracker(use,tracker)
     tracker.use_cases << use
  end

  def self.notification_task_modified(user_id,project_id,tracker)
     users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
     if !users.empty?
       users.each do |u|
         if u.member_id.nil? and u.task_modified==true and !u.user_id.nil?
           user=User.find(u.user_id)
           first_name=tracker.find_user_first_name(user.id)
           UserMailer.notification_task_modified(user,tracker,first_name).deliver
         else if !u.member_id.nil? and u.task_modified==true and !u.user_id.nil?
           user=Member.find(u.member_id)
           first_name=tracker.find_member_first_name(user.id)
           UserMailer.notification_task_modified(user,tracker,first_name).deliver
         end
         end
       end
     end

   end
  def find_member_first_name(id)
              user=Member.find(id)
              if !user.first_name.nil?
                if !user.first_name.empty?
                  return first_name=user.first_name
                else
                  return first_name=user.email
                end
              else
                return first_name=user.email
              end
      end

      def find_user_first_name(id)

              user=User.find(id)
              address=user.address
              if !address.first_name.nil?
                 if !address.first_name.empty?
                    return first_name=address.first_name
                 else
                    return first_name=user.email
                 end
              else
                return first_name=user.email
              end

      end

  def find_first_name_email(u)
         if !u.user_id.nil? and !u.member_id.nil?
          user=Member.find(u.member_id)
          if !user.first_name.nil?
            if !user.first_name.empty?
              return first_name=user.first_name
            else
              return first_name=user.email
            end
          else
            return first_name=user.email
          end
       else !u.user_id.nil? and u.member_id.nil?
          user=User.find(u.user_id)
          address=user.address
          if !address.first_name.nil?
             if !address.first_name.empty?
                return first_name=address.first_name
             else
                return first_name=user.email
             end
          else
            return first_name=user.email
          end
       end
      end


  def find_first_name(u)
     if !u.user_id.nil? and !u.member_id.nil?
        user=Member.find(u.member_id)
        return first_name=user.first_name
     else !u.user_id.nil? and u.member_id.nil?
        user=User.find(u.user_id)
        address=user.address
        return first_name=address.first_name
     end
   end

end
