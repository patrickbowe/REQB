class Member::MemberSessionsController < ApplicationController

  #before_filter :require_no_member, :only => [:new, :create]
  before_filter :require_member, :only => :destroy

 def index
   
 end

  def new

    @member_session = MemberSession.new

  end

  def create

    @member_session = MemberSession.new(params[:member_session])

    if @member_session.save
      @member=Member.find(current_member.id)
      session[:admin_id]=@member.user_id
      flash[:notice] = "Login successful!"

      redirect_back_or_default root_url

    else

      render :action => :new

    end

  end

  def destroy

    current_member_session.destroy
    session.destroy
    flash[:notice] = "Logout successful!"

    redirect_back_or_default :member_login

  end


end
