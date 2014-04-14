require 'redmine_acts_as_taggable_on/initialize'

Redmine::Plugin.register :redmine_crm do
  requires_acts_as_taggable_on
  name 'CRM plugin'
  author 'Mathias Rong'
  description 'A Plugin for managing external companies and contacts in Redmine'
  version '0.1.0'
  url 'https://github.com/rongworks/redmine_crm'
  author_url 'https://github.com/rongworks'

  require_dependency 'projects_relation_patch'

  project_module :redmine_crm do
    permission :view_companies, :companies => [:index, :show]
    permission :edit_companies, :companies => [:edit, :import]
    permission :create_companies, :companies => :new
    permission :organize_contacts, :clients => [:new, :edit]
    permission :view_contacts, :clients => [:index, :show]
  end

  menu :top_menu, :companies, { :controller => 'companies', :action => 'index' }, :caption => 'CRM', :last => true, :if => Proc.new {User.current.admin?}
  menu :project_menu, :companies, { :controller => 'companies', :action => 'index'}, :caption => 'CRM',:param => :project_id

  settings :partial => 'settings/crm_settings', :default => {
      :root_project => nil
  }

  class CrmViewListener < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(context)
      stylesheet_link_tag 'CRMstyle', :plugin => 'redmine_crm'
    end
  end
end
