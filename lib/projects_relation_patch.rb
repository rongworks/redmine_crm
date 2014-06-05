require_dependency 'project'

module ProjectsRelationPatch
  def self.included(base) # :nodoc:

    # Same as typing in the class
    base.class_eval do
      has_many :companies_projects
      has_many :companies, :through => :companies_projects
    end

  end

end

# Add module to Issue
Project.send(:include, ProjectsRelationPatch)