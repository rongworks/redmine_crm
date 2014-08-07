class Company < ActiveRecord::Base
  unloadable

  acts_as_taggable_on :tags, :branches

  belongs_to :primary_contact, :class_name => 'Client', :foreign_key => 'primary_contact_id'
  has_many :clients, :dependent => :destroy
  has_many :crmcomments, as: :commentable, :dependent => :destroy
  has_many :companies_projects,  :class_name => 'CompaniesProjects', :foreign_key => 'company_id', :dependent => :destroy
  has_many :projects, :through => :companies_projects
  has_many :company_crm_actions, :dependent => :destroy
  has_many :crm_actions, :through => :company_crm_actions
  has_many :attached_documents, :as => :container, :dependent => :destroy

  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  validates :name, presence: true
  before_create :add_root_project

  #scope :from_project, lambda { |project_id|
  #  includes(:companies_projects).where('companies_projects.project_id = ?',  project_id)
  #}
  def self.from_project(project_id)
    includes(:companies_projects).where('companies_projects.project_id = ?',  project_id)
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: "#{Setting.plugin_redmine_crm['csv_encoding']}:utf8", col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |row|
    company = find_by_id(row["id"]) || new
    company.attributes = row.to_hash
    company.id = row['id']
    if company.name.blank?
      company.name = 'company' + '#' + row['id']
    end
    if company.branch.blank? && company.branch_list.count > 0
      company.branch = company.branch_list[0]
    end
    if(row['project_ids']).present?
      company.project_ids = row['project_ids'].split(',')
    end
    #  company = Company.new(row.to_hash)
    company.save
    end
  end

  def self.to_csv(items)
   CSV.generate(col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |csv|
      csv << column_names + %w(tag_list branch_list project_ids)
      items.each do |item|
        csv << item.attributes.values_at(*column_names) + ([item.tag_list.join(',')]) + ([item.branch_list.join(',')]) + ([item.project_ids.join(',')])
      end
   end

  end

  def quick_info
    "#{branch}, #{zip_code} #{province},  #{url}"
  end

  def last_comment
    crmcomments.last
  end

  def self.get_all_tags
    tags  = Array.new
    Company.all.each do |company|
      tags.concat(company.tag_list)
    end
    return tags.uniq
  end

  def self.get_all_branches
    branches  = Array.new
    Company.all.each do |company|
      branches.concat(company.branch_list)
    end
    return branches.uniq
  end

  def to_s
    name
  end

  def add_root_project
    root_project = Setting.plugin_redmine_crm['root_project']
    if root_project.present?
      project = Project.find(root_project)
      projects << project unless projects.include? project
    end
  end

  def self.reset_primary_contacts
    Company.all.each do |company|
      company.primary_contact = company.clients.first unless company.clients.empty?
      company.save
    end
  end
end
