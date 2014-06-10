require_dependency 'project'

module ProjectsRelationPatch
  def self.included(base) # :nodoc:
    # Add module to Project
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    #Add relations
    base.class_eval do
      has_many :companies_projects, :class_name => 'CompaniesProjects', :foreign_key => 'project_id'
      has_many :companies, :through => :companies_projects
      has_many :crm_actions, :through => :companies
      has_many :clients, :through => :companies
    end

  end

  module ClassMethods

  end

  module InstanceMethods

  end
end

