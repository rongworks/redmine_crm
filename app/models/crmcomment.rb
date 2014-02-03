class Crmcomment < ActiveRecord::Base
  unloadable

  belongs_to :commentable, polymorphic: true

  validates :user, presence: true
  validates :dtime, :comment, presence: true


end
