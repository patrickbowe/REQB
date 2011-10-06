class DefinitionsController < ApplicationController
  def index
     find_user
     assign_project_use
     @project=Project.find(session[:project_id])
     @defs=@project.definitions.find(:all,:order=>"term")

  end
  def show
      @def=Definition.find(params[:id])
      find_user
      assign_project_use
    end

  def create_term
    @project=Project.find(session[:project_id])
    def1=params[:def]
    find_user
    if !@project.nil? and !current_user.nil?
      if !def1.eql?("<< Add definition")
         @term=@project.definitions.create(:term=>params[:term],:user_id=>@user.id,:definition=>params[:def])
      else
         @term=@project.definitions.create(:term=>params[:term],:user_id=>@user.id)
      end   
    else
     if !@project.nil? and !current_member.nil? and !def1.eql?("<< Add definition")
      if !def1.eql?("<< Add definition")
         @term=@project.definitions.create(:term=>params[:term],:member_id=>@user.id,:user_id=>@user.user_id,:definition=>params[:def])
      else
         @term=@project.definitions.create(:term=>params[:term],:member_id=>@user.id,:user_id=>@user.user_id)
      end
     end

    end
    respond_to do |format|
      @defs=@project.definitions.find(:all,:order=>"term")
      format.js
    end
end    



 def destroy_def
   @term=Definition.find(params[:id])
        if !@term.nil?
          @term.destroy
   end
   redirect_to definitions_path
 end

 def edit_def
     @term=Definition.find(params[:id])
     id=params[:id]
     @term.update_attributes(:term=>params[:"term_#{id}"],:definition=>params[:"definition_#{id}"])
     redirect_to definitions_path
 end

  def sort_def
    find_user
    assign_project_use
    @defs=Definition.find(:all,:conditions=>["project_id=?",session[:project_id]],:order => "#{params[:name]}")
    
  end

  def search_def
    find_user
    assign_project_use
    @defs=Definition.find(:all,:conditions=>["project_id=? and term ILIKE ?",session[:project_id],"#{params[:name]}%"])

  end
  private
  def find_user
        if !current_user.nil?
          @user=User.find(current_user.id)
        else
          @user=Member.find(current_member.id)
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


end
