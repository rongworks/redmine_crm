class Company < ActiveRecord::Base
  unloadable

  acts_as_taggable

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
end
