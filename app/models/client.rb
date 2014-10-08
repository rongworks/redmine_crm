
class Client < ActiveRecord::Base
  unloadable
  belongs_to :company
  has_many :crmcomments, as: :commentable, :dependent => :destroy
  has_many :attached_documents, as: :container, dependent: :destroy
  has_many :crm_reminders, as: :remindable, dependent: :destroy

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

  def to_vcard
    card = Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.prefix = title
        name.given = first_name
        name.family = last_name
      end
      if company
        maker.add_addr do |addr|
          addr.preferred = true
          addr.location = 'work'
          addr.street = company.street if company.street
          addr.locality = company.province if company.province
          addr.postalcode = company.zip_code if company.zip_code
        end
        maker.org = company.name
      end
      maker.add_tel(phone) do |tel|
        tel.location = 'work'
        tel.capability = 'voice'
        tel.preferred = true
      end
      if phone_mobile
        maker.add_tel(phone_mobile) do |tel|
          tel.location = 'cell'
        end
      end
      if fax
        maker.add_tel(fax) do |tel|
          tel.location = 'work'
          tel.capability = 'fax'
        end
      end
      maker.add_email email
      maker.title=department
    end
  end

  def project
    project_id = Setting.plugin_redmine_crm['root_project']
    return Project.where(:id => project_id).first
  end
end
