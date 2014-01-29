class Company < ActiveRecord::Base
  unloadable

  has_many :clients

  validates :name, presence: true



  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      #company = find_by_id(row["id"]) || new
     # company.attributes = row.to_hash.slice(:name)
      company = Company.new(row.to_hash)
      company.save!
    end
  end


end
