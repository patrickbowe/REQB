class User < ActiveRecord::Base
  #acts_as_authentic do |config|
   # config.validate_email_field false
  #end
  has_one :user_plan,:dependent => :destroy
  has_one :address,:dependent => :destroy
  has_many :members,:dependent => :destroy
  has_many :projects,:dependent => :destroy
  has_many :requirements,:dependent => :destroy
  has_many :use_cases,:dependent => :destroy
  has_many :trackers,:dependent => :destroy
  has_many :definitions, :dependent=>:destroy
  has_many :project_files,:dependent=>:destroy
  has_many :help_requests,:dependent=>:destroy
  has_many :notifications,:dependent => :destroy
  has_many :notification_message,:dependent => :destroy
  acts_as_authentic do |c|
      c.login_field = :email
      c.merge_validates_length_of_password_field_options :minimum => 6
      c.merge_validates_length_of_password_confirmation_field_options :minimum => 6
    end
   attr_accessor :old_password
  #validates_length_of :password, :minimum => 8

  def deliver_password_reset_instructions!
      reset_perishable_token!
      UserMailer.password_reset(self).deliver
  end

  def active?
   active
  end

  def activate!
   self.active = true
   self.save
  end

  def deactivate!
    self.active = false
    save
  end

  def send_activation_instructions!
    reset_perishable_token!
    UserMailer.activation_instructions(self).deliver
  end

  def send_activation_confirmation!

    reset_perishable_token!
    user_plan=self.user_plan
    plan=Plan.find(user_plan.plan_id)
    UserMailer.activation_confirmation(self,user_plan,plan).deliver
  end

  
end
