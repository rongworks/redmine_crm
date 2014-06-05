class Company < ActiveRecord::Base
  unloadable

  acts_as_taggable

  has_many :clients, :dependent => :destroy
  has_many :crmcomments, as: :commentable, :dependent => :destroy
  has_many :companies_projects,  :class_name => 'CompaniesProjects', :foreign_key => 'company_id', :dependent => :destroy
  has_many :projects, :through => :companies_projects

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
    CSV.foreach(file.path, headers: true, encoding: 'windows-1252:utf-8') do |row|
    company = find_by_id(row["id"]) || new
    company.attributes = row.to_hash
    company.id = row['id']
    if company.name.blank?
      company.name = 'company' + '#' + row['id']
    end
    #  company = Company.new(row.to_hash)
    company.save
    end
  end

  def quick_info
    "#{branch}, #{zip_code} #{province},  #{url}"
  end

  def last_comment
    crmcomments.last
  end

  def self.get_all_tags
    @tags  = Array.new
    Company.all.each do |company|
      @tags.concat(company.tag_list)
    end
    return @tags.uniq
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
end
