require 'redmine_acts_as_taggable_on/initialize'

Redmine::Plugin.register :redmine_crm do
  requires_acts_as_taggable_on
  name 'CRM plugin'
  author 'Mathias Rong'
  description 'A Plugin for managing external companies and contacts in Redmine'
  version '0.2.1'
  url 'https://github.com/rongworks/redmine_crm'
  author_url 'https://github.com/rongworks'



  # Including dispatcher.rb in case of Rails 2.x
  require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

  if Rails::VERSION::MAJOR >= 3
    ActionDispatch::Callbacks.to_prepare do
      require_dependency 'projects_relation_patch'
      Project.send(:include, ProjectsRelationPatch)
    end
  else
    Dispatcher.to_prepare BW_AssetHelpers::PLUGIN_NAME do
      require_dependency 'projects_relation_patch'
      Project.send(:include, ProjectsRelationPatch)
    end
  end

  project_module :redmine_crm do
    permission :view_companies, :companies => [:index, :show]
    permission :edit_companies, :companies => [:edit, :import]
    permission :create_companies, :companies => :new
    permission :edit_contacts, :clients => [:new, :edit, :import]
    permission :view_contacts, :clients => [:index, :show]
    permission :view_crm_actions, :crm_actions => [:index, :show]
    permission :edit_crm_actions, :crm_actions => [:new, :edit, :import]
    permission :add_documents, :attached_documents => [:new, :edit]
    permission :delete_documents, :attached_documents => [:delete]
    permission :lock_documents, :attached_documents => [:switch_locked]
  end

  menu :top_menu, :companies, { :controller => 'companies', :action => 'index' }, :caption => 'CRM', :last => true, :if => Proc.new {User.current.admin?}
  menu :project_menu, :companies, { :controller => 'companies', :action => 'index'}, :caption => 'CRM',:param => :project_id

  settings :default =>{'root_project' => nil, 'csv_delimiter' => ',', 'csv_encoding' => 'utf8'},
           :partial => 'settings/crm_settings'

  class CrmViewListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      stylesheet_link_tag 'CRMstyle', :plugin => 'redmine_crm'
    end
  end
end
