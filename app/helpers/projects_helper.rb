module ProjectsHelper
  def check_attachment(id)
    reqs=Requirement.find(:all,:conditions=>["project_id=?",id])
    use_cases=UseCase.find(:all,:conditions=>["project_id=?",id])
    def1=Definition.find(:all,:conditions=>["project_id=?",id])
    file1=ProjectFile.find(:all,:conditions=>["project_id=?",id])
    tracker=Tracker.find(:all,:conditions=>["project_id=?",id])
    flag="false"
    if reqs.empty? and use_cases.empty? and def1.empty? and file1.empty? and tracker.empty?
      flag="true"
    end
    return flag
  end
end
