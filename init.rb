Redmine::Plugin.register :crm do
  name 'Crm plugin'
  author 'Mathias Rong'
  description 'A Plugin for managing customers in Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :crm do
    permission :view_companies, :companies => [:index, :show]
    permission :edit_companies, :companies => [:edit, :import]
    permission :create_companies, :companies => :new
    permission :organize_contacts, :clients => [:new, :edit]
    permission :view_contacts, :clients => [:index, :show]
  end

  menu :top_menu, :companies, { :controller => 'companies', :action => 'index' }, :caption => 'CRM', :last => true
  menu :project_menu, :companies, { :controller => 'companies', :action => 'index'}, :caption => 'CRM',:param => :project_id
end
