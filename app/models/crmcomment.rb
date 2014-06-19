class Crmcomment < ActiveRecord::Base
  unloadable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :commentable, presence: true
  validates :user, presence: true
  validates :dtime, :comment, presence: true

  def self.to_csv(items)
    CSV.generate(:col_sep => ';') do |csv|
      csv << column_names
      items.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

end
