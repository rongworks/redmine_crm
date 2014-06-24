class CrmAction < ActiveRecord::Base
  unloadable

  acts_as_taggable
  acts_as_attachable :view_permission => :view_crm_actions,
                     :delete_permission => :edit_crm_actions

  has_many :company_crm_actions, :dependent => :destroy
  has_many :companies, :through => :company_crm_actions
  has_many :crmcomments, as: :commentable, :dependent => :destroy

  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  def project
    project_id = Setting.plugin_redmine_crm['root_project']
    return Project.where(:id => project_id).first
  end

  def self.to_csv(items)
    CSV.generate do |csv|
      csv << column_names + %w(company_ids)
      items.each do |item|
        csv << item.attributes.values_at(*column_names) + item.company_ids
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'windows-1252:utf-8') do |row|
      crm_action = find_by_id(row['id']) || new
      crm_action.attributes = row.to_hash
      crm_action.id = row['id']
      if row['company_ids'].present?
        crm_action.company_ids = row['company_ids'].split(',')
      end
      crm_action.save
    end
  end
end
