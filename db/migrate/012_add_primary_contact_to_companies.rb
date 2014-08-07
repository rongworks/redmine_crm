class AddPrimaryContactToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :primary_contact_id, :integer
    add_index :companies, :primary_contact_id
  end
end