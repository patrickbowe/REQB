require "aws/s3"
class ProjectFilesController < ApplicationController

  def index
    find_user
    assign_project
    @project=Project.find(session[:project_id])
    @files=@project.project_files.find(:all,:order => "created_at desc")
    @file=ProjectFile.new
    if !current_user.nil?
      @flag=check_storage(@user.id)
    else
      @flag=check_storage(@user.user_id)
    end
  end

  def create
    @project=Project.find(session[:project_id])
    @file = @project.project_files.create(params[:project_file])
    find_user
    if !current_user.nil?
       @file.update_attributes(:user_id=>@user.id)
    else
       @file.update_attributes(:user_id=>@user.user_id,:member_id=>@user.id)
    end
    user_plan=UserPlan.find_all_by_user_id(@file.user_id)
    user_plan[0].update_attributes(:storage=>user_plan[0].storage + @file.file_file_size)
    redirect_to project_files_path
  end

  def destroy
    @file=ProjectFile.find(params[:id])
    find_user
    if !@file.nil?
      storage1=@file.file_file_size.to_i
      @file.file.destroy
      if !current_user.nil?
        user_plan=UserPlan.find_by_user_id(@user.id)
      else
        user_plan=UserPlan.find_by_user_id(@user.user_id)
      end
      @file.destroy
      user_plan.update_attributes(:storage=>user_plan.storage-storage1)
    end
    redirect_to project_files_path
  end

  def edit
    @file=ProjectFile.find(params[:id])

    if !@file.nil?
      @file.update_attributes(:type1=>params[:type],:description=>params[:des])
    end  
    redirect_to project_files_path
  end

  def show
       @file=ProjectFile.find(params[:id])
       find_user
     end

  # create and delete comment that are related to file
  def create_comment
    @file=ProjectFile.find(params[:id])
    find_user
    if !current_user.nil? and !@file.nil?
      @comment=@file.comments.create(:title=>params[:comment],:user_id=>@user.id)
    elsif  !current_member.nil? and !@file.nil?
      @comment=@file.comments.create(:title=>params[:comment],:user_id=>@user.user_id,:member_id=>@user.id)
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
      redirect_to project_files_path
  end

  #show matched file name
  def match_file_name

    file1=params[:char]
    @files=ProjectFile.find(:all,:conditions=>["file_file_name LIKE ? and project_id=?","#{file1}%",session[:project_id]])
     respond_to do |format|
      format.js { render :json=> @files }
    end
  end

  #Linked a file with a requirement
  def create_link_req
    @file1=ProjectFile.find(:all,:conditions=>["file_file_name LIKE ?",params[:file_name].to_s+'.'+params[:ext1]])
    @req=Requirement.find(session[:req_id])
    #@req.project_files
    if !@file1.nil?
      #@file1[0].requirements.all
      if !@file1.empty?
        flag=ProjectFile.find_link_req(@req,@file1[0])
        if flag==false
           ProjectFile.insert_req_file(@req,@file1[0])
           @file=@file1[0]
        end
      end  
    end
    find_user
    respond_to do |format|
      format.js 
    end
  end
#Unlink a file with a requirement
def destroy_file_req
    find_user
    @file=ProjectFile.find(params[:id])
    @req=Requirement.find(session[:req_id])
    if !@file.nil?
      @file.requirements.delete(@req)
    end
    redirect_to show_files_url(session[:req_id])
  end

  #Edit linked file with a requirement
  def edit_file_req
    @file=ProjectFile.find(params[:id])
    find_user
     if !@file.nil?
      @file.update_attributes(:type1=>params[:type],:description=>params[:des])
    end
    redirect_to show_files_url(session[:req_id])
  end

  #Linked a file with a usecase
  def create_link_use
    @file1=ProjectFile.find(:all,:conditions=>["file_file_name LIKE ?",params[:file_name].to_s+'.'+params[:ext1]])
    @use=UseCase.find(session[:use_case_id])
    if !@file1.nil?
      if !@file1.empty?
        flag=ProjectFile.find_link_use(@use,@file1[0])
        if flag==false
           ProjectFile.insert_use_file(@use,@file1[0])
           @file=@file1[0]
        end
      end
    end
    find_user
    respond_to do |format|
      format.js
    end
  end
#Unlink a file with a usecase
def destroy_file_use
    find_user
    @file=ProjectFile.find(params[:id])
    @use=UseCase.find(session[:use_case_id])
    if !@file.nil?
      @file.use_cases.delete(@use)
    end
    redirect_to show_files_use_url(session[:use_case_id])
  end

  #Edit linked file with a usecase
  def edit_file_use
    @file=ProjectFile.find(params[:id])
    find_user
     if !@file.nil?
      @file.update_attributes(:type1=>params[:type],:description=>params[:des])
    end
    redirect_to show_files_use_url(session[:use_case_id])
  end

  def sort_file
      find_user
      assign_project
      @files=ProjectFile.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "#{params[:name]}")
      if !current_user.nil?
        @flag=check_storage(@user.id)
      else
        @flag=check_storage(@user.user_id)
      end
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

   def check_storage(user_id)
    user_plan=UserPlan.find_by_user_id(user_id)
    plan=Plan.find(user_plan.plan_id)
    storage1=user_plan.storage/1024*1024
    storage1=storage1.to_s+"mb"
    if plan.storage > storage1
      return flag=true.to_s
    else
      return flag=false.to_s
    end
  end
end
