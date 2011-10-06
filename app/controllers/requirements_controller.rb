class RequirementsController < ApplicationController

  def index
      assign_project
      find_user
      @requirements=Requirement.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "created_at desc")
      
  end

  def create
    assign_project
    find_user
    if !params[:req_name].empty?
      @project=Project.find(session[:project_id])
      if !current_user.nil?
         @project_req=@project.requirements.create(:type1=>"Non Functional",:name=>params[:req_name],:category=>"Uncategorised",:status=>"Draft",:user_id=>@user.id)
      else
         @project_req=@project.requirements.create(:type1=>"Non Functional",:name=>params[:req_name],:category=>"Uncategorised",:status=>"Draft",:user_id=>@user.user_id,:member_id=>@user.id)
      end
      @project_req.save
      #@project_req=Requirement.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "created_at desc",:limit=>1)
      respond_to do |format|
        #format.html { redirect_to requirements_path}
        format.js

    end
    end
  end

  def edit
    @req=Requirement.find(params[:id])
      if @req.update_attributes(:status=>params[:status][0],:category=>params[:category][0],:type1=>params[:type1][0],:importance=>params[:importance][0],:priority=>params[:priority][0],:verification=>params[:verification][0],:name=>params[:description])
        #flash[:notice] = "Project updated!"
        redirect_to requirements_path
      else
        redirect_to :back
      end
  end

  def show
    @req=Requirement.find(params[:id])
    find_user
  end
  def destroy
    find_user
    @req=Requirement.find(params[:id])
    use_cases=@req.use_cases.find :all
    if @user.privilige=="Admin" and @req.status=="Approved"
       if @req.destroy
         delete_usecase(use_cases)
         redirect_to requirements_path
       else
         redirect_to :back
       end
    else if @user.privilige!="Read" and @user.privilige!="Approve" and @req.status!="Approved"
       if @req.destroy
         delete_usecase(use_cases)
         redirect_to requirements_path
       else
         redirect_to :back
       end
    else
       redirect_to :back
    end  
  end
  end

  #create maximum 10 requirements
  def create_requirements
    name=params[:name]
    status=params[:status]
    category=params[:category]                                     
    type1=params[:type1]
    assign_project
    find_user
    @project=Project.find(session[:project_id])
    for i in 1..10 do
      if !name[i.to_s].empty?
        require1=@project.requirements.create(:name=>name[i.to_s],:user_id=>@user.id,:status=>status[i.to_s][0],:type1=>type1[i.to_s][0],:category=>category[i.to_s][0])
        require1.save
      end
    end
    redirect_to requirements_path
  end

 #show use cases that are linked  to requirement
 def show_use_case
      assign_project
      find_user
      req=Requirement.find(params[:req])
      @req_use_cases=req.use_cases.find(:all,:order => "updated_at desc")
      session[:req_id]=req.id
      respond_to do |format|
        format.html {render "use_cases/index"}  
      end

 end

  #match requirement name 
  def match_requirement_name

      @requirement=Requirement.find(:all,:conditions=>["name LIKE ? and project_id=?","#{params[:char]}%",session[:project_id]])
       respond_to do |format|
        format.js { render :json=> @requirement }
      end
    end

  #Linked a requirement with  given an usecase 
  def create_requirement_use
       @requirement1=Requirement.find(:all,:conditions=>["name LIKE ?",params[:requirement]])
        if !@requirement1.nil?
          if !@requirement1.empty?
              @use=UseCase.find(session[:use_case_id])
              flag=Requirement.find_link_req_use(@use,@requirement1[0])
              if flag==false
               Requirement.insert_req_use(@use,@requirement1[0])
               @usecase_req=@requirement1[0]
              end
          end
       end
       find_user
       respond_to do |format|
               format.js
       end
      
   end

  #Unlinked a requirement with a given use_case
  def destroy_requirement_use
    @user=find_user
    @use_req=Requirement.find(params[:id])
    @use_case=UseCase.find(session[:use_case_id])
        if !@use_case.nil?
          @use_req.use_cases.delete(@use_case)
        end
    respond_to do |format|
         format.html {redirect_to show_requirements_url(@use_case.id)}
    end
    

  end

  #Edit linked a requirement
  def edit_requirement_use

     @use_case=UseCase.find(session[:use_case_id])
      @req=Requirement.find(params[:id])
         if !@req.nil?
           @req.update_attributes(:status=>params[:status][0],:category=>params[:category][0],:type1=>params[:type1][0],:importance=>params[:importance][0],:priority=>params[:priority][0],:verification=>params[:verification][0],:name=>params[:description])
         end
      @user=find_user
      redirect_to show_requirements_url(@use_case.id)
      
   end

  def show_tracker
      assign_project
      find_user
      req=Requirement.find(params[:req])
      @all_user=Tracker.find_all_user
      @tracker_reqs=Tracker.find_tracker_by_req(req)
      #@tracker_reqs=req.trackers.find(:all,:order => "updated_at desc")
      session[:req_id]=req.id
      respond_to do |format|
        format.html {render "trackers/index"}  
      end

  end

  #create and delete comments that are related to requirement
  def create_comment
   @req=Requirement.find(params[:id])
   find_user
   if !current_user.nil? and !@req.nil?
     @comment=@req.comments.create(:title=>params[:comment],:user_id=>@user.id)
   elsif  !current_member.nil? and !@req.nil?
     @comment=@req.comments.create(:title=>params[:comment],:user_id=>@user.user_id,:member_id=>@user.id)
   end

   respond_to do |format|
        format.js  
   end
  end

  def delete_comment
   @comment=Comment.find(params[:id])
   if !@comment.nil?
      @comment.destroy
   end
     redirect_to requirements_path
  end

  #show files that are linked to a requirement
  def show_file
      assign_project
      find_user
      req=Requirement.find(params[:req])
      @file_reqs=req.project_files.find :all
      session[:req_id]=req.id
      respond_to do |format|
        format.html {render "project_files/index"}
      end

  end

  def sort_requirement
      assign_project
      find_user
      @requirements=Requirement.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "#{params[:name]}")
  end
 private

       def assign_project
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

      def find_user
        if !current_user.nil?
          @user=User.find(current_user.id)
        else
          @user=Member.find(current_member.id)
        end
      end

    def delete_usecase(use_cases)

    if !use_cases.nil?
      use_cases.each do |use_case|
        use=UseCase.find(use_case.id)
         if !use.nil?
            use.destroy
         end
      end
    end
  end
end
