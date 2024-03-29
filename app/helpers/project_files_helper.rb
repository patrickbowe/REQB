module ProjectFilesHelper
  def find_user_name_of_file(file1)
    result=file1.find_first_name_email(file1)
  end

  def add_comment_file_field(name,file1,user)
     if file1.comments.count==0
       link_to_function name,:title=>"Modify Comments" do |page|
          page << "$('#comment_#{file1.id}').html('#{escape_javascript(render('project_files/comment',:file1 => file1,:user=>user))}');"
       end
     else
       link_to_function name,:title=>"Linked comments - #{file1.comments.count}" do |page|
          page << "$('#comment_#{file1.id}').html('#{escape_javascript(render('project_files/comment',:file1 => file1,:user=>user))}');"
       end
    end
    end
  def check_attachment_file(id)
      return flag=ProjectFile.check_attached_file_items(id)
   end

  def add_file_edit_field(name,file)

    link_to_function name do |page|
      page << "$('#edit_#{file.id}').html('#{escape_javascript(render('project_files/edit',:f => file))}');"
    end

  end

  def remove_file_edit_field(name,file)
      link_to_function name do |page|
        page << "$('#edit_#{file.id}').html('#{escape_javascript('')}');"

      end
  end

  def add_file_edit_req_field(name,file)

      link_to_function name do |page|
        page << "$('#edit_#{file.id}').html('#{escape_javascript(render('project_files/edit_req',:f => file))}');"
      end

    end

    def remove_file_edit_req_field(name,file)
        link_to_function name do |page|
          page << "$('#edit_#{file.id}').html('#{escape_javascript('')}');"

        end
    end

  def add_file_edit_use_field(name,file)

        link_to_function name do |page|
          page << "$('#edit_#{file.id}').html('#{escape_javascript(render('project_files/edit_use',:f => file))}');"
        end

      end

      def remove_file_edit_use_field(name,file)
          link_to_function name do |page|
            page << "$('#edit_#{file.id}').html('#{escape_javascript('')}');"

          end
      end

  
end
