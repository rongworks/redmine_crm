class CrmAction < ActiveRecord::Base
  unloadable

  acts_as_taggable
  acts_as_attachable :view_permission => :view_crm_actions,
                     :delete_permission => :edit_crm_actions

  has_many :company_crm_actions, :dependent => :destroy
  has_many :companies, :through => :company_crm_actions
  has_many :crmcomments, as: :commentable, :dependent => :destroy

  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  attr_accessor :company_names

  after_save :assign_companies

  def project
    project_id = Setting.plugin_redmine_crm['root_project']
    return Project.where(:id => project_id).first
  end

  def self.to_csv(items)
    a = Iconv.new(Setting.plugin_redmine_crm['csv_encoding'], 'UTF-8')
    a.iconv(CSV.generate(col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |csv|
      csv << column_names + %w(company_ids)
      items.each do |item|
        csv << item.attributes.values_at(*column_names) + [item.company_ids.join(',')]
      end
    end)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: "#{Setting.plugin_redmine_crm['csv_encoding']}:utf8", col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |row|
      crm_action = find_by_id(row['id']) || new
      crm_action.attributes = row.to_hash
      crm_action.id = row['id']
      if row['company_ids'].present?
        crm_action.company_ids = row['company_ids'].split(',')
      end
      crm_action.save
    end
  end

  private

  def assign_companies
    if @company_names
      self.companies = @company_names.split(',').map{ |name|
        Company.find_by_name(name.strip)}.reject{|c| c.nil?}
    end
  end
end
