class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.references :company
      t.string :first_name
      t.string :last_name
      t.string :title
      t.string :salutation
      t.string :salutation_letter
      t.string :department
      t.string :phone
      t.string :fax
      t.string :email
    end
    add_index :clients, :company_id
  end
end
