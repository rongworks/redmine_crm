
class Client < ActiveRecord::Base
  unloadable
  belongs_to :company
  has_many :crmcomments, as: :commentable, :dependent => :destroy
  has_many :attached_documents, as: :container, dependent: :destroy
  has_many :reminders, as: :remindable, dependent: :destroy

  accepts_nested_attributes_for :crmcomments, :allow_destroy => true
  accepts_nested_attributes_for :attached_documents, :allow_destroy => true

  validates :last_name, presence: true
  scope :none, where('1 = 0')

  def self.from_project(project)
    Client.where(:company_id => CompaniesProjects.where(:project_id => project.id).map(&:company_id) )
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: "#{Setting.plugin_redmine_crm['csv_encoding']}:utf8", col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |row|
      client = find_by_id(row['id']) || new
      client.attributes = row.to_hash.except('company_name')
      if row['id'].present?
        client.id = row['id']
      end
      if row['company_name'].present?
        client.company = Company.find_by_name(row['company_name'])
      end
      client.save
    end
  end

  def self.to_csv(items)
    CSV.generate(col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |csv|
      csv << column_names + %w(company_name)
      items.each do |item|
        csv << item.attributes.values_at(*column_names) + [item.company.name]
      end
    end
  end

  def to_s
    if first_name.blank?
      last_name
    else
      last_name + ', ' + first_name
    end
  end

  def project
    project_id = Setting.plugin_redmine_crm['root_project']
    return Project.where(:id => project_id).first
  end
end
