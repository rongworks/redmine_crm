Redmine::Plugin.register :crm do
  name 'CRM plugin'
  author 'Mathias Rong'
  description 'A Plugin for managing customers in Redmine'
  version '0.1b'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  require_dependency 'projects_relation_patch'

  project_module :CRM do
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
      stylesheet_link_tag 'CRMstyle', :plugin => 'crm'
    end
  end
end
