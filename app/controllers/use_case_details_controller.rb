class UseCaseDetailsController < ApplicationController
  before_filter :store_location,:only => [:show_pre_condition,:show_alter_flow,:show_basic_flows]
  def index
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
      @pre_conditions=@use_case.pre_conditions.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end
  end

  def index_post_conditions
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
      @post_conditions=@use_case.post_conditions.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_success_conditions
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
      @succ_conditions=@use_case.success_conditions.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_triggers
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
       @triggers=@use_case.triggers.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_actors
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
       @actors=@use_case.actors.find(:all,:conditions=>["flag=?",false],:order=>"created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_business_rules
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
       @business_rules=@use_case.business_rules.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_basic_flows
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
       @basic_flows=@use_case.basic_flows.order("seq_number ASC")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_alternate_flows
    @basic_flow=BasicFlow.find(params[:id])
    show_conditions(@basic_flow.use_case_id)
    if !session[:use_case_id].nil? and !@user.nil?
      session[:basic_flow_id]=@basic_flow.id
      @alternate_flows=@basic_flow.alternate_flows :all
      render "index_alternate_flows"
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def index_messages
    show_conditions(params[:id])
    if !session[:use_case_id].nil? and !@user.nil?
      @messages=@use_case.messages.order("created_at desc")
    elsif session[:use_case_id].nil? and !@user.nil?
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
    else
      redirect_to sign_in_url
    end

  end

  def create_pre_condition
    if !session[:use_case_id].nil?
       @use_case=UseCase.find(session[:use_case_id])
       if !params[:pre].empty? and !@use_case.nil?
         @pre=@use_case.pre_conditions.create(:title=>params[:pre])
       end
    end

  end

  def delete_pre_condition
    @pre_condition=PreCondition.find(params[:value])
    if !@pre_condition.nil?
      @pre_condition.destroy
    end
    if !session[:use_case_id].nil?
      redirect_to use_case_details_path(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end  
  end

  def edit_pre_condition
    @pre_condition=PreCondition.find(params[:id])
    id=params[:id]
    @pre_condition.update_attributes(:title=>params[:"pre_condition_#{id}"])
    if !session[:use_case_id].nil?
      redirect_to use_case_details_path(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def create_post_condition
    if !session[:use_case_id].nil?
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:post].empty? and !@use_case.nil?
        @post=@use_case.post_conditions.create(:title=>params[:post])
      end
   
    end
  end

  def delete_post_condition
    @post_condition=PostCondition.find(params[:value])
    if !@post_condition.nil?
      @post_condition.destroy
    end
    if !session[:use_case_id].nil?
     redirect_to post_conditions_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end  
  end

  def edit_post_condition
    @post_condition=PostCondition.find(params[:id])
    id=params[:id]
    @post_condition.update_attributes(:title=>params[:"post_condition_#{id}"])
    if !session[:use_case_id].nil?
      redirect_to post_conditions_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end


  def create_success_condition
    if !session[:use_case_id].nil?
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:succ].empty? and !@use_case.nil?
        @succ=@use_case.success_conditions.create(:title=>params[:succ])
      end
    end
  end

  def delete_success_condition
    @succ_condition=SuccessCondition.find(params[:value])
    if !@succ_condition.nil?
      @succ_condition.destroy
    end
    if !session[:use_case_id].nil?
     redirect_to success_conditions_url(:id=>session[:use_case_id])
    else
     redirect_to use_cases_path
   end
  end

  def edit_succ_condition
    @succ_condition=SuccessCondition.find(params[:id])
    id=params[:id]
    @succ_condition.update_attributes(:title=>params[:"succ_condition_#{id}"])
    if !session[:use_case_id].nil?
      redirect_to success_conditions_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end


  def create_trigger
    @use_case=UseCase.find(session[:use_case_id])
    #@use_case_details=@use_case.use_case_detail
    if !params[:trigger].empty? and !@use_case.nil?
      @trigger=@use_case.triggers.create(:title=>params[:trigger])
    end
  end

  def delete_trigger
    @trigger=Trigger.find(params[:value])
    if !@trigger.nil?
      @trigger.destroy
    end
    if !session[:use_case_id].nil?
      redirect_to triggers_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def edit_trigger_condition
    @trigger=Trigger.find(params[:id])
    id=params[:id]
    @trigger.update_attributes(:title=>params[:"trigger_#{id}"])
    if !session[:use_case_id].nil?
     redirect_to triggers_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def create_actor
   if !session[:use_case_id].nil?
    @use_case=UseCase.find(session[:use_case_id])
    #@use_case_details=@use_case.use_case_detail
    if !params[:actor].empty? and !@use_case.nil?
      @actor=@use_case.actors.create(:title=>params[:actor])
    end
   end  
  end

  def delete_actor
    @actor=Actor.find(params[:value])
    if !@actor.nil?
      @actor.destroy
    end
    redirect_to attributes_url
  end

  def edit_actor
    @actor=Actor.find(params[:id])
    id=params[:id]
    @actor.update_attributes(:flag=>true)
    if !session[:use_case_id].nil?
      redirect_to actors_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def create_business_rule
   if !session[:use_case_id].nil?
    @use_case=UseCase.find(session[:use_case_id])
    #@use_case_details=@use_case.use_case_detail
    if !params[:rule].empty? and !@use_case.nil?
      @rule=@use_case.business_rules.create(:title=>params[:rule])
    end
   end  
  end

  def delete_business_rule
    @rule=BusinessRule.find(params[:id])
    if !@rule.nil?
      @rule.destroy
    end
    if !session[:use_case_id].nil?
      redirect_to business_rules_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def edit_business_condition
    @rule=BusinessRule.find(params[:id])
    id=params[:id]
    @rule.update_attributes(:title=>params[:"business_rule_#{id}"])
    if !session[:use_case_id].nil?
       redirect_to business_rules_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end  
  end

  def create_message
    if !session[:use_case_id].nil?
     @use_case=UseCase.find(session[:use_case_id])
     #@use_case_details=@use_case.use_case_detail
     if !params[:msg].empty? and !@use_case.nil?
      @message=@use_case.messages.create(:title=>params[:msg])
     end
    end  
  end

  def delete_message
    @message=Message.find(params[:id])
    if !@message.nil?
      @message.destroy
    end
    if !session[:use_case_id].nil?
      redirect_to message_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end  
  end

  def edit_message
     @message=Message.find(params[:id])
     id=params[:id]
     @message.update_attributes(:title=>params[:"message_#{id}"],:content=>params[:"message_content_#{id}"])
     if !session[:use_case_id].nil?
       redirect_to message_url(:id=>session[:use_case_id])
     else
       redirect_to use_cases_path
     end
   end


  def seq_change
    @seq_change=BasicFlow.find(:all, :conditions=>["id=?", params[:id2]])
    @seq_change.each do |i|
      i.update_attributes(:seq_number=>params[:seq])
    end
  end

  def create_basic_flow
    if !session[:use_case_id].nil?
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !@use_case.nil?
       @basic_flow=@use_case.basic_flows.create(:action=>params[:action1])
       @basic_flow_count=@use_case.basic_flows.count
       @basic_flow.update_attributes(:seq_number=>@basic_flow_count)
      end
    end
  end


  def create_basic_flow1
    if !session[:use_case_id].nil?
       @use_case=UseCase.find(session[:use_case_id])
       #@use_case_details=@use_case.use_case_detail
       if !@use_case.nil?
        @basic_flow=@use_case.basic_flows.create(:action=>params[:action1], :response=>params[:response1])
        @basic_flow_count=@use_case.basic_flows.count
        @basic_flow.update_attributes(:seq_number=>@basic_flow_count)
       end
    end
  end

  def create_basic_flow2
    if !session[:use_case_id].nil?
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !@use_case.nil?
       @basic_flow=@use_case.basic_flows.create(:response=>params[:response1])
       @basic_flow_count=@use_case.basic_flows.count
       @basic_flow.update_attributes(:seq_number=>@basic_flow_count)
      end
    end
  end

  def delete_basic_flow
    @basic_flow=BasicFlow.find(params[:id])
    seq_number=@basic_flow.seq_number
    if !@basic_flow.nil?
      @basic_flow.destroy
      all_basics=BasicFlow.find(:all,:conditions=>["seq_number > ?",seq_number])
      if !all_basics.empty?
        all_basics.each do |basic|
          basic.update_attributes(:seq_number=>basic.seq_number-1)
        end  
        end
    end
    if !session[:use_case_id].nil?
      redirect_to basic_flow_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def edit_basic_flow
    @basic_flow=BasicFlow.find(params[:id])
    id=params[:id]
    @basic_flow.update_attributes(:action=>params[:"basic_action_#{id}"], :response=>params[:"basic_response_#{id}"])
    if !session[:use_case_id].nil?
      redirect_to basic_flow_url(:id=>session[:use_case_id])
    else
      redirect_to use_cases_path
    end
  end

  def create_alter_flow
   if !session[:basic_flow_id].nil?
    basic_flow=BasicFlow.find(session[:basic_flow_id])
    if !basic_flow.nil?
      @alternate_flow=basic_flow.alternate_flows.create(:title=>params[:title])
    end
   end  
  end

  def delete_alternate_flow
    @alternate_flow=AlternateFlow.find(params[:id])
    if !@alternate_flow.nil?
      @alternate_flow.destroy
    end
    if !session[:basic_flow_id].nil?
      redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
    else
      redirect_to use_cases_path
    end
  end

  def edit_alternate_flow
    @alternate_flow=AlternateFlow.find(params[:id])
    id=params[:id]
    @alternate_flow.update_attributes(:title=>params[:"alternate_flow_#{id}"])
    if !session[:basic_flow_id].nil?
      redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
    else
      redirect_to use_cases_path
    end
  end
  def seq_change1
    @seq_change=AlternateBasicFlow.find(:all, :conditions=>["id=?", params[:id2]])
    @seq_change.each do |i|
      i.update_attributes(:seq_number=>params[:seq])
    end
  end

  def create_alter_basic_flow
    @alter_flow=AlternateFlow.find(params[:id])

    if !@alter_flow.nil?
      @alter_basic=@alter_flow.alternate_basic_flows.create(:action=>params[:action1])
      @alter_flow_count=@alter_flow.alternate_basic_flows.count
       @alter_basic.update_attributes(:seq_number=>@alter_flow_count)
    end
  end


  def create_alter_basic_flow1
    @alter_flow=AlternateFlow.find(params[:id])
    if !@alter_flow.nil?
      @alter_basic=@alter_flow.alternate_basic_flows.create(:action=>params[:action1], :response=>params[:response1])
      @alter_flow_count=@alter_flow.alternate_basic_flows.count
     @alter_basic.update_attributes(:seq_number=>@alter_flow_count)
    end
  end

  def create_alter_basic_flow2
    @alter_flow=AlternateFlow.find(params[:id])
    if !@alter_flow.nil?
      @alter_basic=@alter_flow.alternate_basic_flows.create(:response=>params[:response1])
      @alter_flow_count=@alter_flow.alternate_basic_flows.count
    @alter_basic.update_attributes(:seq_number=>@alter_flow_count)
    end
  end

  def delete_alter_basic_flow
    @alter_basic=AlternateBasicFlow.find(params[:id])
    seq_number=@alter_basic.seq_number
    if !@alter_basic.nil?
      @alter_basic.destroy
      all_basics=AlternateBasicFlow.find(:all,:conditions=>["seq_number > ?",seq_number])
            if !all_basics.empty?
              all_basics.each do |basic|
                basic.update_attributes(:seq_number=>basic.seq_number-1)
              end
           end
    end
    if !session[:basic_flow_id].nil?
      redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
    else
      redirect_to use_cases_path
    end
  end

  def edit_alter_basic_flow
    @alter_basic=AlternateBasicFlow.find(params[:id])
    id=params[:id]
    @alter_basic.update_attributes(:action=>params[:action1], :response=>params[:response1])
    
  end


  def show_basic_flows
   @basic=BasicFlow.find(params[:id])
   show_conditions(@basic.use_case_id)
   if current_user.nil? and current_member.nil?
          session[:project_id]=@use_case.project_id
          redirect_to sign_in_url
   elsif !session[:use_case_id].nil?
       @user=find_user
       render "show_basic_flows"
   else
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path
   end
 end  

  def show_alter_flow
   @alter=AlternateFlow.find(params[:id])
   @basic=BasicFlow.find(@alter.basic_flow_id)
   show_conditions(@basic.use_case_id)
   if current_user.nil? and current_member.nil?
             session[:project_id]=@use_case.project_id
             redirect_to sign_in_url
   elsif !session[:use_case_id].nil?
      @user=find_user
       render "show_alter_flow"
   else
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path  
   end
  end

 def show_pre_condition
   @pre=PreCondition.find(params[:id])
   show_conditions(@pre.use_case_id)
   if current_user.nil? and current_member.nil?
                session[:project_id]=@use_case.project_id
                redirect_to sign_in_url
   elsif !session[:use_case_id].nil?
      @user=find_user
      render "show_pre_condition"
   else
      flash[:notice]=t(:permisson_for_page)
      redirect_to use_cases_path  
   end
  end

  private
  def find_user
    if !current_user.nil?
      @user=User.find(current_user.id)
      session[:admin_id]=@user.id
    elsif !current_member.nil?
      @user=Member.find(current_member.id)
      session[:admin_id]=@user.user_id
    end
    return @user
  end

  def assign_project_use
    if !session[:project_id].nil?
      find_project=Project.find_by_id(session[:project_id])
      if find_project.nil?
        project=Project.assign_project_id(session[:admin_id])
        if !project.empty?
          session[:project_id]=project[0].id
        end
      end
    end
  end

  def show_conditions(use_case_id)
    find_user
    if !@user.nil?
       use_case=UseCase.find(:all,:conditions=>["user_id=? and id=?",session[:admin_id],use_case_id])
       if !use_case.empty?
           @use_case=use_case[0]
           session[:use_case_id]=@use_case.id
       else
           session[:use_case_id]=nil
       end
    end
  end

end
