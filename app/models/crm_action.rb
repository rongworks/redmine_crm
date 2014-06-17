class CrmAction < ActiveRecord::Base
  unloadable

  acts_as_taggable
  acts_as_attachable :view_permission => :view_crm_actions,
                     :delete_permission => :edit_crm_actions

  has_many :company_crm_actions
  has_many :companies, :through => :company_crm_actions
  has_many :crmcomments, as: :commentable, :dependent => :destroy

  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  def project
    project_id = Setting.plugin_redmine_crm['root_project']
    return Project.where(:id => project_id).first
  end

  def self.to_csv(items)
    CSV.generate(:col_sep => ';') do |csv|
      csv << column_names
      items.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end
end
