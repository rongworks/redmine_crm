class CompaniesProjects < ActiveRecord::Base
  unloadable

  belongs_to :company
  belongs_to :project
end
