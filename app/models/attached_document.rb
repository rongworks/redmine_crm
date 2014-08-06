require 'carrierwave'
require 'carrierwave/orm/activerecord'
class AttachedDocument < ActiveRecord::Base
  unloadable


  belongs_to :user
  belongs_to :lock_holder, :class_name => 'User', :foreign_key => 'lock_holder_id'
  belongs_to :container, polymorphic: true

  mount_uploader :file, DocumentUploader

  validates_presence_of :file, :container, :user

  before_save :update_file_attributes

  private

  def update_file_attributes
    if file.present? && file_changed?
      self.content_type = file.file.content_type
      self.size = file.file.size
      self.filename = file.identifier
      self.last_update = Time.now
    end
  end
end
