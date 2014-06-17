class Client < ActiveRecord::Base
  unloadable

  belongs_to :company
  has_many :crmcomments, as: :commentable, :dependent => :destroy
  accepts_nested_attributes_for :crmcomments, :allow_destroy => true
  acts_as_attachable :view_permission => :organize_contacts,
                     :delete_permission => :organize_contacts

  validates :last_name, presence: true
  scope :none, where('1 = 0')

  def self.from_project(project)
    Client.where(:company_id => CompaniesProjects.where(:project_id => project.id).map(&:company_id) )
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'windows-1252:utf-8') do |row|
      client = find_by_id(row['id']) || new
      client.attributes = row.to_hash
      client.id = row['id']
      client.save
    end
  end

  def self.to_csv(items)
    CSV.generate(:col_sep => ';') do |csv|
      csv << column_names
      items.each do |item|
        csv << item.attributes.values_at(*column_names)
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
