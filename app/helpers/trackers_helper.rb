module TrackersHelper
  def check_attachment_tracker(tracker)
   return flag=Tracker.check_attached_tracker_items(tracker.id)  
  end

  def add_edit_tracker_field(name,tracker)
      link_to_function name do |page|
         page << "$('#edit_#{tracker.id}').html('#{escape_javascript(render('trackers/edit',:tracker => tracker))}');"
      end

  end

  def find_user_name_tracker(tracker)
    result=tracker.find_user_name
  end

  def remove_edit_tracker_field(name,tracker)
      link_to_function name do |page|
        page << "$('#edit_#{tracker.id}').html('#{escape_javascript('')}');"

      end
  end

  def add_edit_tracker_req_field(name,tracker)
       link_to_function name do |page|
         if !tracker.nil?
          page << "$('#edit_#{tracker.id}').html('#{escape_javascript(render('trackers/edit_req',:tracker => tracker))}');"
        end   
       end

   end

  def remove_edit_tracker_req_field(name,tracker)
        link_to_function name do |page|
          page << "$('#edit_#{tracker.id}').html('#{escape_javascript('')}');"

        end
    end

  def add_edit_tracker_use_field(name,tracker)
         link_to_function name do |page|
            page << "$('#edit_#{tracker.id}').html('#{escape_javascript(render('trackers/edit_use',:tracker => tracker))}');"
         end

     end

    def remove_edit_tracker_use_field(name,tracker)
          link_to_function name do |page|
            page << "$('#edit_#{tracker.id}').html('#{escape_javascript('')}');"

          end
    end

   def add_comment_tracker_field(name,tracker,user)
        link_to_function name,:title=>tracker.comments.count do |page|
          page << "$('#comment_#{tracker.id}').html('#{escape_javascript(render('trackers/comment',:tracker => tracker,:user=>user))}');"

        end
    end


end
