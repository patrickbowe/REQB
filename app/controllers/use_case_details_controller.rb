class UseCaseDetailsController < ApplicationController

  def index
    show_conditions(params[:id])
    @pre_conditions=@use_case.pre_conditions.order("created_at desc")
  end

  def index_post_conditions
    show_conditions(params[:id])
    @post_conditions=@use_case.post_conditions.order("created_at desc")

  end

  def index_success_conditions
    show_conditions(params[:id])
    @succ_conditions=@use_case.success_conditions.order("created_at desc")
  end

  def index_triggers
      show_conditions(params[:id])
      @triggers=@use_case.triggers.order("created_at desc")
  end

  def index_actors
      show_conditions(params[:id])
      @actors=@use_case.actors.order("created_at desc")

  end

  def index_business_rules
      show_conditions(params[:id])
      @business_rules=@use_case.business_rules.order("created_at desc")

  end

  def index_basic_flows
     show_conditions(params[:id])
     @basic_flows=@use_case.basic_flows :all
     
  end

  def index_alternate_flows
     @basic_flow=BasicFlow.find(params[:id])
     session[:basic_flow_id]=@basic_flow.id
     show_conditions(@basic_flow.use_case_id)
     @alternate_flows=@basic_flow.alternate_flows :all
     render "index_alternate_flows"

  end

  def index_messages
        show_conditions(params[:id])
        @messages=@use_case.messages.order("created_at desc")
    end
  
  def create_pre_condition
    @use_case=UseCase.find(session[:use_case_id])
    #@use_case_details=@use_case.use_case_detail
    if !params[:pre].empty? and !@use_case.nil?
      @pre=@use_case.pre_conditions.create(:title=>params[:pre])
    end
  end

  def delete_pre_condition
    @pre_condition=PreCondition.find(params[:value])
    if !@pre_condition.nil?
      @pre_condition.destroy
    end
    redirect_to use_case_details_path(:id=>session[:use_case_id])
  end

  def edit_pre_condition
    @pre_condition=PreCondition.find(params[:id])
    id=params[:id]
    @pre_condition.update_attributes(:title=>params[:"pre_condition_#{id}"])
    redirect_to use_case_details_path(:id=>session[:use_case_id])
  end

  def create_post_condition
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:post].empty? and !@use_case.nil?
        @post=@use_case.post_conditions.create(:title=>params[:post])
      end
    end

    def delete_post_condition
      @post_condition=PostCondition.find(params[:value])
      if !@post_condition.nil?
        @post_condition.destroy
      end
       redirect_to post_conditions_url(:id=>session[:use_case_id])
    end

  def edit_post_condition
    @post_condition=PostCondition.find(params[:id])
    id=params[:id]
    @post_condition.update_attributes(:title=>params[:"post_condition_#{id}"])
    redirect_to post_conditions_url(:id=>session[:use_case_id])
  end


  def create_success_condition
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:succ].empty? and !@use_case.nil?
        @succ=@use_case.success_conditions.create(:title=>params[:succ])
      end
  end

      def delete_success_condition
        @succ_condition=SuccessCondition.find(params[:value])
        if !@succ_condition.nil?
           @succ_condition.destroy
        end
       redirect_to success_conditions_url(:id=>session[:use_case_id])
      end

    def edit_succ_condition
       @succ_condition=SuccessCondition.find(params[:id])
       id=params[:id]
       @succ_condition.update_attributes(:title=>params[:"succ_condition_#{id}"])
       redirect_to success_conditions_url(:id=>session[:use_case_id])
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
          redirect_to triggers_url(:id=>session[:use_case_id])
    end

     def edit_trigger_condition
       @trigger=Trigger.find(params[:id])
       id=params[:id]
       @trigger.update_attributes(:title=>params[:"trigger_#{id}"])
       redirect_to triggers_url(:id=>session[:use_case_id])
    end

       def create_actor
            @use_case=UseCase.find(session[:use_case_id])
            #@use_case_details=@use_case.use_case_detail
            if !params[:actor].empty? and !@use_case.nil?
             @actor=@use_case.actors.create(:title=>params[:actor])
            end
          end

          def delete_actor
            @actor=Actor.find(params[:value])
            if !@actor.nil?
              @actor.destroy
            end
            redirect_to actors_url(:id=>session[:use_case_id])
          end

    def edit_actor
       @actor=Actor.find(params[:id])
       id=params[:id]
       @actor.update_attributes(:title=>params[:"actor_#{id}"])
       redirect_to actors_url(:id=>session[:use_case_id])
    end

   def create_business_rule
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:rule].empty? and !@use_case.nil?
        @rule=@use_case.business_rules.create(:title=>params[:rule])
      end
   end

   def delete_business_rule
     @rule=BusinessRule.find(params[:id])
          if !@rule.nil?
            @rule.destroy
     end
     redirect_to business_rules_url(:id=>session[:use_case_id])
   end

   def edit_business_condition
       @rule=BusinessRule.find(params[:id])
       id=params[:id]
       @rule.update_attributes(:title=>params[:"business_rule_#{id}"])
       redirect_to business_rules_url(:id=>session[:use_case_id])
    end

  def create_message
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !params[:msg].empty? and !@use_case.nil?
        @message=@use_case.messages.create(:title=>params[:msg])
      end
     end

     def delete_message
       @message=Message.find(params[:id])
          if !@message.nil?
            @message.destroy
       end
       redirect_to message_url(:id=>session[:use_case_id])
     end

    def edit
      @message=Message.find(params[:id])
      id=params[:id]
      @message.update_attributes(:title=>params[:"message_#{id}"],:content=>params[:content])
      redirect_to message_url(:id=>session[:use_case_id])
    end


    def create_basic_flow
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !@use_case.nil?
        @basic_flow=@use_case.basic_flows.create(:action=>params[:action1])
        @basic_flow_count=@use_case.basic_flows.count
      end
   end

  def create_basic_flow1
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !@use_case.nil?
        @basic_flow=@use_case.basic_flows.create(:action=>params[:action1],:response=>params[:response1])
        @basic_flow_count=@use_case.basic_flows.count
      end
  end

  def create_basic_flow2
      @use_case=UseCase.find(session[:use_case_id])
      #@use_case_details=@use_case.use_case_detail
      if !@use_case.nil?
        @basic_flow=@use_case.basic_flows.create(:response=>params[:response1])
        @basic_flow_count=@use_case.basic_flows.count
      end
  end

   def delete_basic_flow
     @basic_flow=BasicFlow.find(params[:id])
          if !@basic_flow.nil?
            @basic_flow.destroy
     end
     redirect_to basic_flow_url(:id=>session[:use_case_id])
   end

   def edit_basic_flow
       @basic_flow=BasicFlow.find(params[:id])
       id=params[:id]
       @basic_flow.update_attributes(:action=>params[:"basic_action_#{id}"],:response=>params[:"basic_response_#{id}"])
       redirect_to basic_flow_url(:id=>session[:use_case_id])
   end

  def create_alter_flow
    basic_flow=BasicFlow.find(session[:basic_flow_id])
    if !basic_flow.nil?
      @alternate_flow=basic_flow.alternate_flows.create(:title=>params[:title])
    end
  end

  def delete_alternate_flow
     @alternate_flow=AlternateFlow.find(params[:id])
          if !@alternate_flow.nil?
            @alternate_flow.destroy
     end
     redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
  end

  def edit_alternate_flow
       @alternate_flow=AlternateFlow.find(params[:id])
       id=params[:id]
       @alternate_flow.update_attributes(:title=>params[:"alternate_flow_#{id}"])
       redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
  end

  def create_alter_basic_flow
      @alter_flow=AlternateFlow.find(params[:id])

      if !@alter_flow.nil?
        @alter_basic=@alter_flow.alternate_basic_flows.create(:action=>params[:action1])
        @alter_flow_count=@alter_flow.alternate_basic_flows.count
      end
   end

  def create_alter_basic_flow1
     @alter_flow=AlternateFlow.find(params[:id])
     if !@alter_flow.nil?
        @alter_basic=@alter_flow.alternate_basic_flows.create(:action=>params[:action1],:response=>params[:response1])
        @alter_flow_count=@alter_flow.alternate_basic_flows.count
      end
  end

  def create_alter_basic_flow2
      @alter_flow=AlternateFlow.find(params[:id])
      if !@alter_flow.nil?
        @alter_basic=@alter_flow.alternate_basic_flows.create(:response=>params[:response1])
        @alter_flow_count=@alter_flow.alternate_basic_flows.count
      end
  end

 def delete_alter_basic_flow
     @alter_basic=AlternateBasicFlow.find(params[:id])
          if !@alter_basic.nil?
            @alter_basic.destroy
     end
     redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
  end

  def edit_alter_basic_flow
         @alter_basic=AlternateBasicFlow.find(params[:id])
         id=params[:id]
         @alter_basic.update_attributes(:action=>params[:"alter_basic_action_#{id}"],:response=>params[:"alter_basic_response_#{id}"])
         redirect_to alternate_flow_url(:id=>session[:basic_flow_id])
    end

  private
  def find_user
      if !current_user.nil?
        user=User.find(current_user.id)
      else
        user=Member.find(current_member.id)
      end
      return user
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
    @user=find_user
    @use_case=UseCase.find(use_case_id)
    #@use_case_details=@use_case.use_case_detail
    session[:use_case_id]=@use_case.id
  end

end
