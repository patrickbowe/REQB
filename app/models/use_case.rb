class UseCase < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :requirements
  has_and_belongs_to_many :trackers
  has_one :use_case_detail,:dependent=>:destroy
  has_many :pre_conditions,:dependent=>:destroy
  has_many :post_conditions,:dependent=>:destroy
  has_many :success_conditions,:dependent=>:destroy
  has_many :triggers,:dependent=>:destroy
  has_many :business_rules,:dependent=>:destroy
  has_many :messages,:dependent=>:destroy
  has_many :actors,:dependent=>:destroy
  has_many :basic_flows,:dependent=>:destroy
  has_many :comments,:dependent=>:destroy
  has_and_belongs_to_many :project_files
  validates_uniqueness_of :name,:scope => [:project_id]
  #validates_uniqueness_of  :name
  def find_user_name_use
    address=Address.find(:all,:conditions=>["user_id=?",self.user_id])
    if !address[0].nil?
     first_name=address[0].first_name.capitalize
    else
     address=Member.find(:all,:conditions=>["id=?",self.user_id])
     first_name=address[0].first_name.capitalize
      
    end  

  end

  def self.check_attached_items(id)
    use_case=UseCase.find(id)
    pre=use_case.pre_conditions.find :all
    post=use_case.post_conditions.find :all
    succ=use_case.success_conditions.find :all
    actor=use_case.actors.find :all
    trigger=use_case.triggers.find :all
    rule=use_case.business_rules.find :all
    msg=use_case.messages.find :all
    use_case_req=use_case.requirements.find :all
    use_case_tracker=use_case.trackers.find :all
    comments=use_case.comments.find :all
    files=use_case.project_files.find :all
    flag="false"
    if use_case_req.empty? and pre.empty? and post.empty? and succ.empty? and rule.empty? and actor.empty? and msg.empty? and trigger.empty? and use_case_tracker.empty? and comments.empty? and files.empty?
      flag="true"
    end
    return flag
  end

  def self.find_link_req_use(req,use)
    req_use=use.requirements.include?(req)

  end

  def self.insert_req_use(req,use)
     use.requirements << req
  end

  def self.find_link_tracker_use(tracker,use)
      tracker_use=use.trackers.include?(tracker)

    end

  def self.insert_tracker_use(tracker,use)
       use.trackers << tracker
    end

  def self.find_link_use_file(file,use)
     use_file=use.project_files.include?(file)

   end

   def self.insert_use_file(file,use)
      use.project_files << file
   end

  def self.notification_create(user_id,project_id,usecase,first_name)
     users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
     if !users.empty?
       users.each do |u|
         if u.member_id.nil? and u.use_created==true and !u.user_id.nil?
           user=User.find(u.user_id)
           #first_name=usecase.find_user_first_name(user.id)
           UserMailer.notification_email_create_use(user,first_name,usecase).deliver
         else if !u.member_id.nil? and u.use_created==true and !u.user_id.nil?
           user=Member.find(u.member_id)
           #first_name=usecase.find_member_first_name(user.id)
           UserMailer.notification_email_create_use(user,first_name,usecase).deliver
         end
         end
       end
     end

   end

   def self.notification_approved(user_id,project_id,usecase,first_name)
       users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
       if !users.empty?
         users.each do |u|
           if u.member_id.nil? and u.use_approved==true and !u.user_id.nil?
             user=User.find(u.user_id)
             #first_name=usecase.find_user_first_name(user.id)
             UserMailer.notification_email_approve_use(user,first_name,usecase).deliver
           else if !u.member_id.nil? and u.use_approved==true and !u.user_id.nil?
             user=Member.find(u.member_id)
             #first_name=usecase.find_member_first_name(user.id)
             UserMailer.notification_email_approve_use(user,first_name,usecase).deliver
           end
           end
         end
       end

     end

   def self.notification_reviewed(user_id,project_id,usecase,first_name)
         users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
         if !users.empty?
           users.each do |u|
             if u.member_id.nil? and u.use_review==true and !u.user_id.nil?
               user=User.find(u.user_id)
               #first_name=usecase.find_user_first_name(user.id)
               UserMailer.notification_email_review_use(user,first_name,usecase).deliver
             else if !u.member_id.nil? and u.use_review==true and !u.user_id.nil?
               user=Member.find(u.member_id)
               #first_name=usecase.find_member_first_name(user.id)
               UserMailer.notification_email_review_use(user,first_name,usecase).deliver
             end
             end
           end
         end

       end

  def self.notification_no_approved(user_id,project_id,usecase,first_name)
         users=Notification.find(:all,:conditions=>["user_id=? and project_id=?",user_id,project_id])
         if !users.empty?
           users.each do |u|
             if u.member_id.nil? and u.use_longer_approved==true and !u.user_id.nil?
               user=User.find(u.user_id)
               #first_name=usecase.find_user_first_name(user.id)
               UserMailer.notification_email_no_approve_use_email(user,first_name,usecase).deliver
             else if !u.member_id.nil? and u.use_longer_approved==true and !u.user_id.nil?
               user=Member.find(u.member_id)
               #first_name=usecase.find_member_first_name(user.id)
               UserMailer.notification_email_no_approve_use_email(user,first_name,usecase).deliver
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
        if (!u.user_id.nil? and !u.member_id.nil?) or (u.user_id.nil? and !u.member_id.nil?)
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
