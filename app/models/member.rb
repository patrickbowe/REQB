class Member < ActiveRecord::Base
  belongs_to :user
  #has_many :projects
  has_many :requirements,:dependent => :destroy
  has_many :use_cases,:dependent => :destroy
  has_many :trackers,:dependent => :destroy
  has_many :peoples,:dependent => :destroy,:class_name=>"Member"
  belongs_to :admin,:class_name=>"Member",:foreign_key => "member_id"
  has_many :projects,:dependent => :destroy
  has_many :definitions, :dependent=>:destroy
  has_many :project_files,:dependent=>:destroy
  has_many :help_requests,:dependent=>:destroy
  acts_as_authentic do |c|
        c.login_field = :email
        c.merge_validates_length_of_password_field_options :minimum => 8
        c.merge_validates_length_of_password_confirmation_field_options :minimum => 8
        
   end
  attr_accessor :old_password
  def deliver_member_activation_instructions!
      reset_perishable_token!
      UserMailer.member_activation(self).deliver
  end

  def send_activation_confirmation!
    reset_perishable_token!
    UserMailer.member_activation_confirmation(self).deliver
  end

  def notify!
     self.notify = true
     self.save
  end

  def deliver_member_password_reset_instructions!
        reset_perishable_token!
        UserMailer.member_password_reset(self).deliver
    end

end
