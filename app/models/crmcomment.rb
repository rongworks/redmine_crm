class Crmcomment < ActiveRecord::Base
  unloadable

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :commentable, presence: true
  validates :user, presence: true
  validates :dtime, :comment, presence: true


end
