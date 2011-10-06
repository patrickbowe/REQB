class UseCasesController < ApplicationController
  def index
      assign_project_use
      @user=find_user
      @use_cases=UseCase.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "created_at desc")

  end

  def create
    assign_project_use
    if !params[:use_case_name].empty?
      @project=Project.find(session[:project_id])
      @user=find_user
      if !current_user.nil?
         @project_use=@project.use_cases.create(:name=>params[:use_case_name],:category=>"Configuration",:status=>"Draft",:user_id=>@user.id)
      else
         @project_use=@project.use_cases.create(:name=>params[:use_case_name],:category=>"Configuration",:status=>"Draft",:user_id=>@user.user_id,:member_id=>@user.id)
      end
      @project_use.save
      respond_to do |format|
         format.js

    end
    end
  end


def edit
    @use_case=UseCase.find(params[:id])
      if @use_case.update_attributes(:status=>params[:status][0],:category=>params[:category][0],:goal=>params[:goal],:name=>params[:description])
        #flash[:notice] = "Project updated!"
        redirect_to use_cases_path
      else
        redirect_to :back
      end
end

  def destroy
    @user=find_user
    @use_case=UseCase.find(params[:id])
    reqs=@use_case.requirements.find :all
    if @user.privilige=="Admin" and @use_case.status=="Approved"
       if @use_case.destroy
         delete_req(reqs)
         redirect_to use_cases_path
       else
         redirect_to :back
       end
    else if @user.privilige!="Read" and @user.privilige!="Approve" and @use_case.status!="Approved"
       if @use_case.destroy
         delete_req(reqs)
         redirect_to use_cases_path
       else
         redirect_to :back
       end
    else
       redirect_to :back
    end
  end
  end

  def show
     @use=UseCase.find(params[:id])
     @user=find_user
   end

  def match_usecase_name

      use_case1=params[:char]
      @use_case=UseCase.find(:all,:conditions=>["name LIKE ? and project_id= ?","#{use_case1}%",session[:project_id]])
       respond_to do |format|
        format.js { render :json=> @use_case }
      end
    end

  #Linked an usecase with a given requirement
  
  def req_create
        @project_use1=UseCase.find(:all,:conditions=>["name LIKE ?",params[:use_case_name]])
        if !@project_use1.nil?
          if !@project_use1.empty?
              @req=Requirement.find(session[:req_id])
              flag=UseCase.find_link_req_use(@req,@project_use1[0])
              if flag==false
               UseCase.insert_req_use(@req,@project_use1[0])
               @project_use=@project_use1[0] 
              end
          end
       end
       @user=find_user
       respond_to do |format|
             format.js
       end
  end
  
  #Edit linked an usecase
  def edit_req_usecase
    @requirement=Requirement.find(session[:req_id])
    @use_case=UseCase.find(params[:id])
      if !@use_case.nil?
       @use_case.update_attributes(:status=>params[:status][0],:category=>params[:category][0],:goal=>params[:goal],:name=>params[:description])
      end
    respond_to do |format|
             format.html {redirect_to show_usecases_url(@requirement.id)}
     end

  end

 #Unlinked an usecase with a given requirement
 def destroy_req_usecase
    find_user
    req=Requirement.find(session[:req_id])
    @use_case=UseCase.find(params[:id])
    if !@use_case.nil?
      @use_case.requirements.delete(req)
    end
      respond_to do |format|
         format.html {redirect_to show_usecases_url(req.id)}
       end
    

 end

  def show_req
    use_case=UseCase.find(params[:id])
    @use_reqs=use_case.requirements.find :all
    @user=find_user
    session[:use_case_id]=use_case.id
    respond_to do |format|
            format.html {render "requirements/index"}  
          end

  end

  def show_tracker_use
      assign_project_use
      find_user
      use=UseCase.find(params[:use])
      @all_user=Tracker.find_all_user
      @tracker_usecases=Tracker.find_tracker_by_req(use)
      #@tracker_reqs=req.trackers.find(:all,:order => "updated_at desc")
      session[:use_case_id]=use.id
      respond_to do |format|
        format.html {render "trackers/index"}  
      end

 end

  def create_comment
    @use=UseCase.find(params[:id])
    @user=find_user
    if !current_user.nil?
      @comment=@use.comments.create(:title=>params[:comment],:user_id=>@user.id)
    else
      @comment=@use.comments.create(:title=>params[:comment],:user_id=>@user.user_id,:member_id=>@user.id)
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
      redirect_to use_cases_path
  end

  #show files that are linked to an usecase
  def show_file_use
      assign_project_use
      @user=find_user
      use=UseCase.find(params[:use])
      @file_uses=use.project_files.find :all
      session[:use_case_id]=use.id
      respond_to do |format|
        format.html {render "project_files/index"}
      end

  end

  def sort_usecase
      assign_project_use
      @user=find_user
      @use_cases=UseCase.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "#{params[:name]}")
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

  def delete_req(reqs)

    if !reqs.nil?
      reqs.each do |req|
        requirement=Requirement.find(req.id)
         if !requirement.nil?
            requirement.destroy
         end
      end
    end  
  end

end
