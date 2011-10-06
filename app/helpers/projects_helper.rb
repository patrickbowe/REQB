module ProjectsHelper
  def check_attachment(id)
    reqs=Requirement.find(:all,:conditions=>["project_id=?",id])
    use_cases=UseCase.find(:all,:conditions=>["project_id=?",id])
    flag="false"
    if reqs.empty? or use_cases.empty?
      flag="true"
    end
    return flag
  end
end
