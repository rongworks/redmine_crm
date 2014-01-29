Redmine::Plugin.register :crm do
  name 'Crm plugin'
  author 'Mathias Rong'
  description 'A Plugin for managing customers in Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :companies, { :companies => [:index] }
  menu :top_menu, :companies, { :controller => 'companies', :action => 'index' }, :caption => 'CRM', :last => true
end
