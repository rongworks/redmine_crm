class Client < ActiveRecord::Base
  unloadable

  belongs_to :company
  has_many :crmcomments, as: :commentable
  accepts_nested_attributes_for :crmcomments, :allow_destroy => true
  acts_as_attachable

  validates :last_name, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'windows-1252:utf-8') do |row|
      client = find_by_id(row['id']) || new
      client.attributes = row.to_hash
      client.id = row['id']
      client.save
    end
  end

  def to_s
    if first_name.blank?
      last_name
    else
      last_name + ', ' + first_name
    end
  end
end
