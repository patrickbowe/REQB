class PasswordResetsController < ApplicationController
  def new

    if current_user.nil? && current_member.nil?
      render "new_password"
    else
      render "new"
    end

  end

  

  def create
   if !current_user.nil?
    @user = User.find_by_email(params[:email])
   elsif !current_member.nil?
    @member = Member.find_by_email(params[:email])
   else
     @user = User.find_by_email(params[:email])
     @member = Member.find_by_email(params[:email])
   end  
   if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
      session.destroy
      if !current_user_session.nil?
        current_user_session.destroy
      end  
      redirect_to login_url
   elsif @member
      @member.deliver_member_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
      session.destroy
      if !current_member_session.nil?
        current_member_session.destroy
      end  
      redirect_to login_url

   else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
   end
   
  end

  def create_password

    @user = User.find_by_email(params[:email])
    @member = Member.find_by_email(params[:email])
   if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
      redirect_to login_url
   elsif @member
      @member.deliver_member_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
      "Please check your email."
      redirect_to login_url

   else
      flash[:notice] = "No user was found with that email address"
      render :action => :new_password
   end

  end

end
