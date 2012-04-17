require 'cheddargetter_client_ruby'
require 'crack'
class PaymentsController < ApplicationController
  layout 'signin', :only=>[:new, :create]

  def new

  end

  def create

    if !params[:plan_type].nil?
      @user=User.find(params[:id])
      client = CheddarGetter::Client.new(:product_code => "3D",
                                         :username => "nikhil.verma@ongraph.com",
                                         :password => "tester")

      plan_type=params[:plan_type][0].split(' ')

      if plan_type[0]=="Free"
        @response_code=client.new_customer(
                :code      => @user.email,
                :firstName => params[:first_name],
                :lastName  => params[:last_name],
                :email     => @user.email,
                :subscription => {
                        :planCode     => plan_type[0],

                        })
      else
        @response_code=client.new_customer(
                :code      => @user.email,
                :firstName => params[:first_name],
                :lastName  => params[:last_name],
                :email     => @user.email,
                :subscription => {
                        :planCode     => plan_type[0],
                        :ccFirstName => params[:first_name],
                        :ccLastName => params[:last_name],
                        :method  => "paypal",
                        :returnUrl => "http://pure-autumn-9167.heroku.com/sign-in",
                        :cancelUrl => "http://pure-autumn-9167.heroku.com/sign-up"

                })
      end
      #puts @response_code.subscription
      if @response_code.valid?
        #puts response.customer_subscription
        if params[:newsletter_check].nil?
          @news=false
        else
          @news=true
        end
        if plan_type[0]=="Free"
          address=Address.create(:first_name=>params[:first_name], :last_name=>params[:last_name], :subscription_url=>params[:subdomain], :billing_address=>params[:address], :city=>params[:city], :zip=>params[:zip], :country=>params[:country][0], :newsletter=>@news, :user_id=>@user.id)
          plan=Plan.find(:all, :conditions=>["plan_type=?", plan_type[0]])
          user_plan=@user.create_user_plan(:plan_id=>plan[0].id, :project_count=>0, :member_count=>0, :storage=>0,:status=>"Approved")
          if !user_plan.nil?
            respond_to do |format|
              @user.send_activation_instructions!
              flash[:notice] = "Account registered,please check your mails."
              format.html { redirect_to signup_complete_url }
            end
          else
            respond_to do |format|
              client.delete_customer(:code=> @user.email)
              flash.now[:notice]="Subscription URL should be unique."
              format.html { render "new" }
            end
          end

        else
          response = client.get_customer(:code => @user.email)
          if !response.nil?
            @redirect_url=response.customer_subscriptions[0][:redirectUrl]
            if !@redirect_url.nil?
              address=Address.create(:first_name=>params[:first_name], :last_name=>params[:last_name], :subscription_url=>params[:subdomain], :billing_address=>params[:address], :city=>params[:city], :zip=>params[:zip], :country=>params[:country][0], :newsletter=>@news, :user_id=>@user.id)
              plan=Plan.find(:all, :conditions=>["plan_type=?", plan_type[0]])
              user_plan=@user.create_user_plan(:plan_id=>plan[0].id, :project_count=>0, :member_count=>0, :storage=>0,:status=>"paypal-wait")
              if !user_plan.nil?
                respond_to do |format|
                  #UserMailer.activation_instructions_for_paypal(@user,url).deliver
                  #flash[:notice] = "Account registered,please check your mails."
                  format.html { redirect_to @redirect_url }
                end
              else
                respond_to do |format|
                  client.delete_customer(:code=> @user.email)
                  flash.now[:notice]="Subscription URL should be unique."
                  format.html { render "new" }
                end

              end
             else
                   respond_to do |format|
                      redirect_to contact_url
                   end
             end
          else
           respond_to do |format|
            redirect_to contact_url
           end   
          end
        end


      else
        respond_to do |format|
          format.html { render "new" }
        end
      end
    else
      respond_to do |format|
        flash.now[:notice]="Plan is not available yet."
        format.html { render "new" }
      end
    end

  end

  
end
