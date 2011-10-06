class UsersController < ApplicationController
    before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:show, :edit, :update]
    
   

    def new
      @user = User.new
    end

    def create
      @user = User.new(params[:user])
      member=Member.find_by_email(params[:user][:email])
      user=User.find_by_email(params[:user][:email])
      @flag_subs=false
      if  !user.nil?
         @flag_subs=check_subscription(user)
      end
    
      @flag_error="false"
      if member.nil? and @flag_subs==false
         if @user.save
          #@user.send_activation_instructions!
          #flash[:notice] = "Account registered!"
          @countries=Country.all
          render new_payment_path
          else
            render :action => :new
          end  
      else
           @flag_error="true"
           render :action => :new
      end
    end

    def show
      @user = @current_user
      @project=Project.find(:all,:conditions=>["user_id=?",@user.id])
      if !@project.empty?
        session[:project_id]=@project[0].id
      end
    end

    def edit
      @user = @current_user
    end

    def update
      @user = @current_user # makes our views "cleaner" and more consistent
      if @user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        redirect_to account_url
      else
        render :action => :edit
      end
    end

  def reset_password
     @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
  end

  def reset_password_submit
    @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
    @user.active = true
    if @user.update_attributes(params[:user].merge({:active => true}))
    #if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully reset password."
      redirect_to root_url
    else
      #flash[:notice] = "There was a problem resetting your password."
      render :action => :reset_password
    end
  end

  def activate
  @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)

  raise Exception if @user.active?

  if @user.activate!
    UserSession.create(@user, true)
    @user.send_activation_confirmation!
    redirect_to root_url
  else
    render :action => :new
  end
  end

  def change_password

    if !current_user.nil?
      @user=User.find(current_user.id)
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
    end  
   @flag="false"
   respond_to do |format|
   if @user.valid_password?(params[:user][:old_password])
     if @user.update_attributes(params[:user].reject{|key, value| key == "old_password"})
       @flag="true"
       format.js
     else
      #flash[:notice] = "There was a problem resetting your password."
      format.html {render :xml=>@user.errors}
      format.js
     end
  else
         flash.now[:notice] = 'Your old password is WRONG!'
         format.html {render :xml=>@user.errors}
         format.js
  end

   end  
    
  end

  def change_email
    user_email=User.find_by_email(params[:object][:email])
    member_email=Member.find_by_email(params[:object][:email])
    @user=User.find(current_user.id)
    if user_email.nil? and member_email.nil?
      UserMailer.email_change_activation(@user,params[:object][:email]).deliver
      flash[:notice]="Email update activation email sent."
      redirect_to account_details_url
    else
      flash[:notice]="Email is already exist"
      redirect_to account_details_url
    end  
  end

  def update_email
      @user=User.find(params[:id])
    if @user.update_attributes(:email=>params[:email])
      flash[:notice]="Your email is updated successfully."
      redirect_to homes_url
    else
      flash[:notice]="Email is already exist"
      redirect_to account_details_url
    end
    
  end

  def resend_activation_link
    @user = User.find_by_email(params[:email])
    respond_to do |format|
           @user.send_activation_instructions!
           flash[:notice] = "Account registered,please check your mails."
           format.html {redirect_to :root}
    end
  end
    
  private
  def check_subscription(user)
    address1=user.address :all
    flag_subs=false
    if address1.nil?
      user.destroy
      flag_subs=false
    else
      flag_subs=true
    end
    return flag_subs
  end
end



