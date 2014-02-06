class Client < ActiveRecord::Base
  unloadable

  belongs_to :company
  has_many :crmcomments, as: :commentable
  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  validates :last_name, presence: true

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      client = find_by_id(row['id']) || new
      client.attributes = row.to_hash
      #TODO: need a way to connect to company
      client.save!
    end
  end

  def to_s
    first_name + ' ' + last_name
  end
end
