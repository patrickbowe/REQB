require 'cheddargetter_client_ruby'
require 'crack'
class PaymentsController < ApplicationController

  def new
    
  end

  def create

    if params[:plan_type].nil?
       @user=User.find(params[:id])
       client = CheddarGetter::Client.new(:product_code => "REQB",
                                   :username => "nikhil.verma@ongraph.com",
                                   :password => "tester")
      @response_code=client.new_customer(
        :code      => @user.email,
        :firstName => params[:first_name],
        :lastName  => params[:last_name],
        :email     => @user.email,
        :subscription => {
        :planCode     => "FREE",
        })
      if @response_code.valid?
        if params[:newsletter_check].nil?
           news=false
        else
          news=true
        end
        address=@user.create_address(:first_name=>params[:first_name],:last_name=>params[:last_name],:billing_address=>params[:address],:city=>params[:city],:zip=>params[:zip],:region=>params[:region],:country=>params[:country][0],:phone=>params[:phone],:newsletter=>news)
        plan=Plan.find(:all,:conditions=>["plan_type=?","FREE"])
        #dir_path=Dir::mkdir(@user.id.to_s + "_test")
        #user_plan=@user.create_user_plan(:plan_id=>plan[0].id,:path=> dir_path)
         user_plan=@user.create_user_plan(:plan_id=>plan[0].id,:project_count=>0)
        respond_to do |format|
           @user.send_activation_instructions!
           flash[:notice] = "Account registered,please check your mails."
           format.html {redirect_to :root}
        end
      else
        respond_to do |format|
           format.html {render "new"}
        end
      end
    else
        respond_to do |format|
           flash.now[:notice]="Payment gateway is not available yet."
           format.html {render "new"}
        end
    end

  end
end
