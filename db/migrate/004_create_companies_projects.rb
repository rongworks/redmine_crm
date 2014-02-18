class CreateCompaniesProjects < ActiveRecord::Migration
  def change
    create_table :companies_projects do |t|
      t.references :project
      t.references :company
    end
    add_index :companies_projects, :project_id
    add_index :companies_projects, :company_id
  end
end
