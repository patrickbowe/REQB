class PasswordResetsController < ApplicationController
  def new
    find_user
    if current_user.nil? && current_member.nil?
      render :layout => 'signin',:action => "new_password"

    else
      render "new"
    end

  end

  

  def create
   if !current_user.nil?
    @user = User.find_by_email(params[:forgot_email])
   elsif !current_member.nil?
    @member = Member.find_by_email(params[:forgot_email])
   else
     @user = User.find_by_email(params[:forgot_email])
     @member = Member.find_by_email(params[:forgot_email])
   end  
   if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Password re-set instructions have been emailed to you."
      session.destroy
      if !current_user_session.nil?
        current_user_session.destroy
      end  
      redirect_to login_url
   elsif @member
      @member.deliver_member_password_reset_instructions!
      flash[:notice] = "Password re-set instructions have been emailed to you."
      session.destroy
      if !current_member_session.nil?
        current_member_session.destroy
      end  
      redirect_to login_url

   else
      flash.now[:notice] = "No user was found with that email address."
      if current_user.nil? and current_member.nil?
         render :layout => 'signin',:action => :new_password
      else
         render :layout => 'signin',:action => :new_password
      end  
   end
   
  end

  def create_password

    @user = User.find_by_email(params[:email])
    @member = Member.find_by_email(params[:email])
   if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Password re-set instructions have been emailed to you."
      redirect_to login_url
   elsif @member
      @member.deliver_member_password_reset_instructions!
      flash[:notice] = "Password re-set instructions have been emailed to you."
      redirect_to login_url

   else
      flash.now[:notice] = "No user was found with that email address."
      render :layout => 'signin',:action => :new_password
   end

  end

  private

 def find_user
        if !current_user.nil?
          @user=User.find(current_user.id)
          @subscriber_id=@user.id
        elsif !current_member.nil?
          @user=Member.find(current_member.id)
          @subscriber_id=@user.user_id
        end
      end
    

end
