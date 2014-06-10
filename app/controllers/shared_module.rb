module SharedModule
  extend ActiveSupport::Concern

  included do
    # class level code
    before_filter :global_access, :find_project
  end

  module ClassMethods
    # all class methods here
  end

  private
  def find_project
    root_project = Setting.plugin_redmine_crm['root_project']
    if params[:project_id]
      @project = Project.find(params[:project_id])
    elsif  root_project.present?
      @project = Project.find(root_project)
    else
      flash[:error] = t(:message_no_root_project)
      redirect_to :home
    end
  end

  def global_access
    authorize unless User.current.admin?
  end
end