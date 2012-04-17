class UserSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  #before_filter :require_user, :only => :destroy
  layout 'signin',:only=>[:new,:create]
  def new
    session.destroy
    @user_session = UserSession.new

  end

  def create

    @user_session = UserSession.new(params[:user_session])
    @member_session=MemberSession.new(params[:user_session])
    @flag_error="false"
    @flag_active="false"
     @flag_subs="false"
    @user=User.find_by_email(params[:user_session][:email])
    @member=Member.find_by_email(params[:user_session][:email])
    if !@user.nil?
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
           @user.update_attributes(:active=>true)
           plan=Plan.find(@user_plan.plan_id)
           UserMailer.activation_confirmation(@user,@user_plan,plan).deliver
         else
           flash[:notice]="Your payment is pending."
           @flag_subs="true"
         end
       end
      end
      if @user.active==false
        @flag_subs=check_subscription(@user)
      end
    elsif !@member.nil?
        subscriber=User.find(@member.user_id)
       if subscriber.status=="paypal-wait"
         flash[:notice]="Your subscriber's payment is pending."
         @flag_subs="true"
       end
    elsif @user.nil? and @member.nil?
      flash[:notice] = "Sorry,you do not have account!!!"
      @flag_subs="true"
    end   

  if @flag_subs=="false"
    if !@user.nil? and @user.active==false
      @flag_active="true"
      render "users/resend_activation"
    elsif !@member.nil? and @member.active==false
          @flag_active="true"
          render :action => :new
    elsif @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default dashboard_url
    elsif @member_session.save
       @user_session=nil
       @member=Member.find(current_member.id)
       session[:admin_id]=@member.user_id
       flash[:notice] = "Login successful!"
       redirect_back_or_default dashboard_url
    else
      @flag_error="true"
      render :action => :new
    end
  else

    redirect_back_or_default sign_in_url
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
    session[:return_to] = nil
    flash[:notice] = "Logout successful!"
    redirect_back_or_default sign_in_url
  end

  private

  def check_subscription(user)
    address1=user.address :all
    flag_subs="false"
    if address1.nil?
      user.destroy
      return flag_subs="true"
    else
      return flag_subs="false"
    end

  end
end
