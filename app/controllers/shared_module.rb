module SharedModule
  extend ActiveSupport::Concern

  included do
    # class level code
    before_filter :find_project, :global_access, :api_access
  end

  module ClassMethods
    # all class methods here
  end

  private

  def api_access
    request.headers['X-Redmine-API-Key'] = User.current.api_key
  end

  def find_project
    root_project = Setting.plugin_redmine_crm['root_project']
    if params[:project_id]
      @project = Project.find(params[:project_id])
    #elsif  root_project.present?
    #  @project = Project.find(root_project)
    #else
    #  flash[:error] = t(:message_no_root_project)
    #  redirect_to :home
    end
  end

  def global_access
    #TODO: check if required
    #authorize unless User.current.admin?
  end

  def get_operating_system(request)
    if request.env['HTTP_USER_AGENT'].downcase.match(/mac/i)
      "Mac"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/windows/i)
      "Windows"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/linux/i)
      "Linux"
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/unix/i)
      "Unix"
    else
      "Unknown"
    end
  end
end