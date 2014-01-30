class Company < ActiveRecord::Base
  unloadable

  has_many :clients
  has_many :crmcomments, as: :commentable
  accepts_nested_attributes_for :crmcomments, :allow_destroy => true

  validates :name, presence: true



  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    company = find_by_id(row["id"]) || new
    company.attributes = row.to_hash
    #  company = Company.new(row.to_hash)
    company.save!
    end
  end


end
