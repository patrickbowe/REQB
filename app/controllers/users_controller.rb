require 'cheddargetter_client_ruby'
require 'crack'
class UsersController < ApplicationController
    before_filter :require_no_user, :only => [:new, :create]
    before_filter :require_user, :only => [:show, :edit, :update]
    layout 'signin',:only=>[:new,:create,:signup_complete,:reset_password,:resend_activation_link]
   
    #To create user instance
    def new
      @user = User.new
    end

    #To create an user
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

    #To show user infromation
    def show
      @user = @current_user
      @project=Project.find(:all,:conditions=>["user_id=?",@user.id])
      if !@project.empty?
        session[:project_id]=@project[0].id
      end
    end

    #To edit user information
    def edit
      @user = @current_user
    end

    #To update user information
    def update
      @user = @current_user # makes our views "cleaner" and more consistent
      if @user.update_attributes(params[:user])
        flash[:notice] = "Account updated!"
        redirect_to account_url
      else
        render :action => :edit
      end
    end

  #To reset password
  def reset_password
     @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
  end


  def reset_password_submit
    @user = User.find_using_perishable_token(params[:reset_password_code], 1.week) || (raise Exception)
    @user.active = true
    if @user.update_attributes(params[:user].merge({:active => true}))
    #if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully reset password."
      redirect_to dashboard_url
    else
      #flash[:notice] = "There was a problem resetting your password."
      render :action => :reset_password
    end
  end

  #To activate user account
  def activate
  session.destroy
  @user = User.find_using_perishable_token(params[:activation_code], 1.week)

  #raise Exception if @user.active?

  if @user.activate!
    UserSession.create(@user, true)
    @user.send_activation_confirmation!

    redirect_to dashboard_url
  else
    render :action => :new
  end
  end

  #To change user password
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
       flash.now[:notice]=t(:password_change_message)
       format.js
     else
      #flash[:notice] = "There was a problem resetting your password."
      format.html {render :xml=>@user.errors}
      format.js
     end
  else
         flash.now[:notice] = t(:existing_password_incorrect)
         format.html {render :xml=>@user.errors}
         format.js
  end

   end  
    
  end

  #To change user email
  def change_email
    user_email=User.find_by_email(params[:object][:email])
    member_email=Member.find_by_email(params[:object][:email])
    @user=User.find(current_user.id)
    if user_email.nil? and member_email.nil?
      UserMailer.email_change_activation(@user,params[:object][:email]).deliver
      flash[:notice]=t(:change_email_message)
      redirect_to account_details_url
    else
      flash[:notice]=t(:unique_email_message)
      redirect_to account_details_url
    end  
  end


  def update_email
      @user=User.find(params[:id])
    if @user.update_attributes(:email=>params[:email])
      flash[:notice]=t(:email_update_message)
      @user.send_activation_confirmation!
      redirect_to dashboard_url
    else
      flash[:notice]=t(:unique_email_message)
      redirect_to account_details_url
    end
    
  end

    #To resend activation link
  def resend_activation_link
    @user = User.find_by_email(params[:email])
    respond_to do |format|
        if !@user.nil?
           @user.send_activation_instructions!
           flash[:notice] = "Account registered,please check your mails."
           format.html {redirect_to sign_in_url}
        else
          flash[:notice]="Please enter valid email address"
          format.html {render "users/resend_activation"}
        end  
    end
  end

  #To check uniqueness of email
  def check_email
    @test_user=User.find_by_email(params[:email])
    if !@test_user.nil?
      @notice=t(:unique_email_message)
    end
     respond_to do |format|

       format.js {render :json => {:result => @notice}}
     end
  end

  def signup_complete
    
  end

  #To check uniqueness of domain
  def check_domain
      subdomain=Address.find(:all,:conditions=>["subscription_url ILIKE?",params[:subdomain]])
      if !subdomain.empty?
        @sub_domain_flag=true
        respond_to do |format|
          format.js {render :json => @sub_domain_flag}
        end
      else
        @sub_domain_flag=false
        respond_to do |format|
          format.js {render :json => @sub_domain_flag}
        end
      end

  end

  #To upgrade/degrade subscription
  def change_subscription
    @user=User.find(current_user.id)
    @user_plan=UserPlan.find_by_user_id(current_user.id)
    @plan_type=params[:plan_type][0].split(' ')
    @user_has_plan=Plan.find(@user_plan.plan_id)
    @flag="false"
    if (@plan_type=="Free" && (@user_has_plan.plan_type=="Project" || @user_has_plan.plan_type=="Program"))
     if @user_plan.project_count > 3
       flash[:notice]=t(:free_downgrade_user_has_too_many_projects_set_up,:count=>@user_plan.project_count)
       flash[:notice] << "<br />"
       @flag="true"
     end
     if @user_plan.member_count > 3
       flash[:notice] << t(:free_downgrade_user_has_too_many_members_set_up,:count=>@user_plan.member_count)
       flash[:notice] << "<br />"
       @flag="true"
     end
     if @user_plan.storage > 52428800
       flash[:notice] << t(:free_downgrade_user_has_too_many_files,:count=>@user_plan.storage)
       flash[:notice] << "<br />"
       @flag="true"
     end 
    elsif (@plan_type=="Project" && @user_has_plan.plan_type=="Program")
       if @user_plan.project_count > 15
       flash[:notice]=t(:project_downgrade_user_has_too_many_projects_set_up,:count=>@user_plan.project_count)
       flash[:notice] << "<br />"
       @flag="true"
       end
     if @user_plan.member_count > 10
       flash[:notice] << t(:project_downgrade_user_has_too_many_members_set_up,:count=>@user_plan.member_count)
       flash[:notice] << "<br />"
       @flag="true"
     end
     if @user_plan.storage > 5368709120
       flash[:notice] << t(:project_downgrade_user_has_too_many_files,:count=>@user_plan.storage)
       flash[:notice] << "<br />"
       @flag="true"
     end
    end  
    if @flag=="false"

          client = CheddarGetter::Client.new(:product_code => "3D",
                                             :username => "nikhil.verma@ongraph.com",
                                             :password => "tester")


          if @plan_type[0]=="Free"
            @response_code=client.edit_customer(
                    {:code      => @user.email},
                    {
                    :email=> @user.email,
                    :subscription => {
                            :planCode     => @plan_type[0],

                            }})
          else
            @response_code=client.edit_customer(
                    {:code      => @user.email},
                    {
                       :email=> @user.email,
                            :subscription => {
                            :planCode     => @plan_type[0],
                            :method  => "paypal",
                            :returnUrl => "http://pure-autumn-9167.heroku.com/verify_subscription",
                            :cancelUrl => "http://pure-autumn-9167.heroku.com/verify_subscription"

                    }})
          end
          if @response_code.valid?
            @plan=Plan.find(:all, :conditions=>["plan_type=?", @plan_type[0]])
            if @plan_type[0]=="Free"
              @user_plan.update_attributes(:plan_id=>@plan[0].id)
              respond_to do |format|
                flash[:notice] = "Your subscription updated successfully."
                format.html { redirect_to account_details_url }
              end
            else
              response = client.get_customer(:code => @user.email)
              if !response.nil?
                @redirect_url=response.customer_subscriptions[0][:redirectUrl]
                if !@redirect_url.nil?
                  @user_plan.update_attributes(:plan_id=>@plan[0].id,:status=>"paypal-wait")
                  respond_to do |format|
                      format.html { redirect_to @redirect_url }
                  end
                else
                  redirect_to account_details_url
                end
              end
            end
          else
            redirect_to account_details_url
          end
     
    else
       redirect_to account_details_url
     end
  end
  #To verify upgrade/degrade subscription
    def verify_subscription
        if !current_user.nil?
          @user=User.find(current_user.id)
          @user_plan=UserPlan.find_by_user_id(@user.id)
          if @user_plan.status=="paypal-wait"
           client = CheddarGetter::Client.new(:product_code => "3D",
                                                     :username => "nikhil.verma@ongraph.com",
                                                     :password => "tester")

           response = client.get_customer(:code => @user.email)
           if !response.nil?
             status=response.customer_subscriptions[0][:cancelType]
             if status.nil?
               @user_plan.update_attributes(:status=>"Approved")
               redirect_to account_details_url
             else
               current_user_session.destroy
               session[:project_id]=nil
               session[:return_to] = nil
               flash[:notice]="Your payment is pending."
               redirect_to sign_in_url               
             end
           end
          else
            redirect_to account_details_url
          end
        else
           redirect_to sign_in_url          
        end
  end
  private
  #To check validity of subscription  
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



