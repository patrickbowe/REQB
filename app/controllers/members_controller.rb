class MembersController < ApplicationController
  #before_filter :require_no_user, :only => [:create]
  #before_filter :require_user, :only => [:show, :edit, :update]
  #layout 'signin',:only=>[:member_activation]
  def index
    if !current_user.nil?
      @user=User.find(current_user.id)
      @members=@user.members.order("created_at desc")
      @flag=check_user_plan(@user.id)
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      @current_member=@user
      @members=Member.find(:all, :conditions=>["user_id=?", @user.user_id])
      @flag=check_user_plan(@user.user_id)
    else
      redirect_to sign_in_url
    end

  end

  def create
    @user=find_user
    if !@user.nil?
      @flag="false"
      @flag_error="false"
      @flag_email_check=nil
      if !current_user.nil?
        @member=@user.members.build
        @flag=check_user_plan(@user.id)
      elsif !current_member.nil?
        @member=@user.members.build
        @flag=check_user_plan(@user.user_id)
      end
      email=params[:member_email1].gsub(/[*]/, '.')
      @member.email=email.to_s
      @member.password="tester1234"
      @member.password_confirmation="tester1234"
      @member.first_name=email.to_s
      @user_email=User.find_by_email(email)
      respond_to do |format|
        if @flag=="true" and @user.privilige=="Admin"
          if @user_email.nil?
            if @member.save
              @member.deliver_member_activation_instructions!
              if !current_user.nil?
                @user_plan=UserPlan.find_by_user_id(@user.id)
                @user_plan.update_attributes(:member_count=>@user_plan.member_count + 1)
                @flag=check_user_plan(@user.id)
                flash.now[:notice]="An email has been sent to #{@member.email} asking them to activate their account."
              else
                @user_plan=UserPlan.find_by_user_id(@user.user_id)
                @user_plan.update_attributes(:member_count=>@user_plan.member_count + 1)
                @flag=check_user_plan(@user.user_id)
                @member.update_attributes(:user_id=>@user.user_id)
                @current_member=@user
                flash.now[:notice]="An email has been sent to #{@member.email} asking them to activate their account."
              end
              #format.html { redirect_to members_path }
              @flag_error="false"
              format.js
            else
              @flag_error="true"
              if !current_user.nil?
                @flag=check_user_plan(@user.id)
              else
                @flag=check_user_plan(@user.user_id)
              end
              #format.html {render :json =>@member.errors.full_messages}
              format.js
            end
          else
            @flag_error="true"
            if !current_user.nil?
              @flag=check_user_plan(@user.id)
            else
              @flag=check_user_plan(@user.user_id)
            end
            @flag_email_check=t(:unique_email_message)
            format.js

          end
        end

      end
    end
  end

  def member_activation
    @member = Member.find_using_perishable_token(params[:member_activation_code], 1.week)
    if !current_user_session.nil?
      current_user_session.destroy
    end
    if !@member.nil?
      render :layout => 'signin', :action => "member_activation"
    else
      flash[:notice]=t(:activation_code)
      redirect_to sign_in_url
    end
  end

  def member_activation_submit
    @member = Member.find_using_perishable_token(params[:member_activation_code], 1.week)
    flag="false"
    if !@member.nil?
      if @member.active==false
        @member.active = true
      else
        flag="true"
      end
      respond_to do |format|
        if @member.update_attributes(params[:member].merge({:active => true}))
          MemberSession.create(@member, true)
          if flag=="false"
            @member.send_activation_confirmation!
          end
          session[:admin_id]=@member.user_id
          format.html { redirect_to dashboard_url }
        else
          #flash[:notice] = "There was a problem in activate your account."
          format.html { render :action => :member_activation }
          format.xml { render :xml=>@member.errors }
        end
      end
    else
      flash[:notice]=t(:activation_code_expired)
      redirect_to sign_in_url
    end
  end

  def edit
    @member=Member.find(params[:id])
    message=""
    if params[:"first_name_#{@member.id}"]!=@member.first_name
      first=params[:"first_name_#{@member.id}"]
      message << "first name as " + first + ","
    end
    if params[:"last_name_#{@member.id}"]!=@member.last_name
      last=params[:"last_name_#{@member.id}"]
      message << "last name as " + last + ","
    end
    if !params[:"privilige_#{@member.id}"].nil?
      if params[:"privilige_#{@member.id}"][0]!=@member.privilige
        privilige=params[:"privilige_#{@member.id}"][0]
        message << "priviliage as " + privilige
      end
    end
    if params[:"email_#{@member.id}"]!=@member.email
      @email=params[:"email_#{@member.id}"]
      message << "email as " + @email + ","
    end
    @flag=check_user_plan(@member.user_id)
    @user_email=User.find_by_email(@email)
    if @user_email.nil?
      if !params[:"privilige_#{@member.id}"].nil?
        @update=@member.update_attributes(:first_name=>params[:"first_name_#{@member.id}"], :last_name=>params[:"last_name_#{@member.id}"], :privilige=>params[:"privilige_#{@member.id}"][0], :email=>params[:"email_#{@member.id}"])
      else
        @update=@member.update_attributes(:first_name=>params[:"first_name_#{@member.id}"], :last_name=>params[:"last_name_#{@member.id}"], :email=>params[:"email_#{@member.id}"])
      end
      if @update==true
        if !message.eql?("")
          UserMailer.member_notification(@member, message, params[:"email_#{@member.id}"]).deliver
        end
        redirect_to members_path
      else
        flash[:notice]=t(:unique_email_message)
        redirect_to :action=>"index"
      end
    else
      flash[:notice]=t(:unique_email_message)
      redirect_to :action=>"index"
    end
  end

  def destroy
    @member=Member.find(params[:id])
    if !@member.nil?
      if @member.destroy
        if !current_user.nil?
          user_plan=UserPlan.find_by_user_id(current_user.id)
          user_plan.update_attributes(:member_count=>user_plan.member_count - 1)
          @flag=check_user_plan(current_user.id)
          redirect_to members_path
        elsif !current_member.nil?
          member=Member.find(current_member.id)
          user_plan=UserPlan.find_by_user_id(member.user_id)
          user_plan.update_attributes(:member_count=>user_plan.member_count - 1)
          @flag=check_user_plan(member.user_id)
          redirect_to members_path
        else
          redirect_to sign_in_url
        end


      end
    else
      redirect_to :back
    end

  end

  def notify
    @member=Member.find(params[:id])
    if @member.notify!
      @member.deliver_member_activation_instructions!
      flash[:notice]="A notification email has been sent"
      redirect_to members_path
    else
      redirect_to :back
    end
  end

  def notification_confirmation
    @member=Member.find(params[:id])
    if @member.notify!
      @member.deliver_member_activation_instructions!
    end

  end

  def change_email_member
    user_email=User.find_by_email(params[:member][:email])
    member_email=Member.find_by_email(params[:member][:email])
    @member=Member.find(current_member.id)
    if !@member.nil?
      if user_email.nil? and member_email.nil?
        UserMailer.email_change_activation_member(@member, params[:member][:email]).deliver
        flash[:notice]=t(:change_email_message)
        redirect_to account_details_url
      else
        flash[:notice]=t(:unique_email_message)
        redirect_to account_details_url
      end
    else
      redirect_to sign_in_url
    end
  end

  def update_email_member

    @member=Member.find(params[:id])

    if @member.update_attributes(:email=>params[:email])
      flash[:notice]=t(:email_update_message)
      @member.send_activation_confirmation!
      redirect_to dashboard_url
    else
      flash[:notice]=t(:unique_email_message)
      redirect_to account_details_url
    end

  end

  private

  def check_user_plan(user_id)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    if plan.member_count.to_i > user_plan.member_count.to_i
      return true.to_s
    else
      return false.to_s
    end

  end

  def find_user
    if !current_user.nil?
      user=User.find(current_user.id)
      session[:admin_id]=user.id
      return user
    elsif !current_member.nil?
      user=Member.find(current_member.id)
      session[:admin_id]=user.user_id
      return user
    end

  end

end
