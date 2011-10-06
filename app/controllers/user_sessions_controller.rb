class UserSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @member_session=MemberSession.new(params[:user_session])
    @flag_error="false"
    @flag_active="false"
     @flag_subs="true"
    @user=User.find_by_email(params[:user_session][:email])
    if !@user.nil?
      if @user.active==false
        @flag_subs=check_subscription(@user)
      end  
    end   
    @member=Member.find_by_email(params[:user_session][:email])
  if @flag_subs=="true"
    if !@user.nil? and @user.active==false
      @flag_active="true"
      render "users/resend_activation"
    elsif !@member.nil? and @member.active==false
          @flag_active="true"
          render :action => :new
    elsif @user_session.save
      flash[:notice] = "Login successful!"
      redirect_to dashboard_url
    elsif @member_session.save
       @user_session=nil
       @member=Member.find(current_member.id)
       session[:admin_id]=@member.user_id
       flash[:notice] = "Login successful!"
       redirect_to dashboard_url
    else
      @flag_error="true"
      render :action => :new
    end
  else
    flash[:notice] = "Sorry,you do not have account!!!"
    redirect_to root_url
  end  
  end

  def destroy
    session.destroy
    if !current_user_session.nil?
      current_user_session.destroy
    elsif !current_member_session.nil?
      current_member_session.destroy
    end  
    session[:project_id]=nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end

  private

  def check_subscription(user)
    address1=user.address :all
    flag_subs="false"
    if address1.nil?
      user.destroy
      flag_subs="false"
    else
      flag_subs="true"
    end
    return flag_subs
  end
end
