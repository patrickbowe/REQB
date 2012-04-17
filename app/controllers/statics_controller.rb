class StaticsController < ApplicationController
  #caches_page :footer_partial
  #To show footer in static page
  def footer_partial
     render :partial => 'statics/footer'
  end

  #To show middle part in static page
  def middle_partial
     render :partial => 'statics/home_middle_content'
  end
end
