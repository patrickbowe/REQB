class Definition < ActiveRecord::Base
  belongs_to :user
  belongs_to :member
  belongs_to :project
  validates_uniqueness_of :term, :scope => [:project_id]

  def self.notification_create(user_id,project_id,term)
      users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
      if !users.empty?
        users.each do |u|
          if u.member_id.nil? and u.def_created==true and !u.user_id.nil?
            user=User.find(u.user_id)
            first_name=term.find_first_name_email(term)
            UserMailer.notification_email_create_def(user,first_name,term).deliver
          else if !u.member_id.nil? and u.def_created==true and !u.user_id.nil?
            user=Member.find(u.member_id)
            first_name=term.find_first_name_email(term)
            UserMailer.notification_email_create_def(user,first_name,term).deliver
          end
          end
        end
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
