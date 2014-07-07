class Crmcomment < ActiveRecord::Base
  unloadable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :commentable, presence: true
  validates :user, presence: true
  validates :dtime, :comment, presence: true

  def self.to_csv(items)
    CSV.generate(col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |csv|
      csv << column_names
      items.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: "#{Setting.plugin_redmine_crm['csv_encoding']}:utf8", col_sep: Setting.plugin_redmine_crm['csv_delimiter']) do |row|
      crm_comment = find_by_id(row['id']) || new
      crm_comment.attributes = row.to_hash
      crm_comment.id = row['id']
      crm_comment.save
    end
  end
end
