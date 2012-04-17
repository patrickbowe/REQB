class Requirement < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :use_cases
  has_and_belongs_to_many :trackers
  has_many :comments,:dependent => :destroy
  has_and_belongs_to_many :project_files
  validates_uniqueness_of :name, :scope => [:project_id]
  #validates_uniqueness_of  :name
  def find_user_name_req
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address.empty?
     first_name=address[0].first_name.capitalize
    else
      address=Member.find(:all,:conditions=>["id=?",self.user_id])
      if !address.first_name.nil? and !address.first_name.empty?
        first_name=address[0].first_name.capitalize
      else
        first_name=address[0].email
      end  
    end
  end

  def self.check_attached_req_items(id)
        req=Requirement.find(id)
        use_case_req=req.use_cases.find :all
        tracker_req=req.trackers.find :all
        comments=req.comments.find :all
        file_req=req.project_files.find :all
        flag="false"
        if use_case_req.empty? and tracker_req.empty? and comments.empty? and file_req.empty?
          flag="true"
        end
        return flag

  end

  def self.find_link_req_use(use,req)
    req_use=req.use_cases.include?(use)

  end

  def self.insert_req_use(use,req)
     req.use_cases << use
  end

  def self.find_link_req_file(file,req)
    req_file=req.project_files.include?(file)

  end

  def self.insert_req_file(file,req)
     req.project_files << file
  end

  def self.notification_create(user_id,project_id,req,first_name)
    users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
    if !users.empty?
      users.each do |u|
        if u.member_id.nil? and u.req_created==true and !u.user_id.nil?
          user=User.find(u.user_id)
          #first_name=req.find_user_first_name(user.id)
          UserMailer.notification_email_create_req(user,first_name,req).deliver
        else if !u.member_id.nil? and u.req_created==true and !u.user_id.nil?
          user=Member.find(u.member_id)
          #first_name=req.find_member_first_name(user.id)
          UserMailer.notification_email_create_req(user,first_name,req).deliver
        end
        end
      end
    end

  end

  def self.notification_approved(user_id,project_id,req,first_name)
      users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
      if !users.empty?
        users.each do |u|
          if u.member_id.nil? and u.req_approved==true and !u.user_id.nil?
            user=User.find(u.user_id)
            #first_name=req.find_user_first_name(user.id)
            UserMailer.notification_email_approve_req(user,first_name,req).deliver
          else if !u.member_id.nil? and u.req_approved==true and !u.user_id.nil?
            user=Member.find(u.member_id)
            #first_name=req.find_member_first_name(user.id)
            UserMailer.notification_email_approve_req(user,first_name,req).deliver
          end
          end
        end
      end

    end

  def self.notification_no_approved(user_id,project_id,req,first_name)
        users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
        if !users.empty?
          users.each do |u|
            if u.member_id.nil? and u.req_longer_approved==true and !u.user_id.nil?
              user=User.find(u.user_id)
              #first_name=req.find_user_first_name(user.id)
              UserMailer.notification_email_no_approve_req(user,first_name,req).deliver
            else if !u.member_id.nil? and u.req_longer_approved==true and !u.user_id.nil?
              user=Member.find(u.member_id)
              #first_name=req.find_member_first_name(user.id)
              UserMailer.notification_email_no_approve_req(user,first_name,req).deliver
            end
            end
          end
        end

      end


  def self.notification_reviewed(user_id,project_id,req,first_name)
        users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
        if !users.empty?
          users.each do |u|
            if u.member_id.nil? and u.req_review==true and !u.user_id.nil?
              user=User.find(u.user_id)
              #first_name=req.find_user_first_name(user.id)
              UserMailer.notification_email_review_req(user,first_name,req).deliver
            else if !u.member_id.nil? and u.req_review==true and !u.user_id.nil?
              user=Member.find(u.member_id)
              #first_name=req.find_member_first_name(user.id)
              UserMailer.notification_email_review_req(user,first_name,req).deliver
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

  def self.find_link_req_tracker(tracker,req)
    req_tracker=req.trackers.include?(tracker)

  end

  def self.insert_req_tracker(tracker,req)
     req.trackers << tracker
  end

end
