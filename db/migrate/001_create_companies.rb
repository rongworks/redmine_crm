class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :extra_information
      t.string :zip_code
      t.string :state
      t.string :province
      t.string :street
      t.string :url
      t.string :mail
      t.string :branch
      t.string :organisation
    end
    add_index :companies, :zip_code
    add_index :companies, :province
    add_index :companies, :branch
    add_index :companies, :organisation
  end
end
