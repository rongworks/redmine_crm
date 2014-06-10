class CreateCompanyCrmActions < ActiveRecord::Migration
  def change
    create_table :company_crm_actions do |t|
      t.references :company
      t.references :crm_action
    end
    add_index :company_crm_actions, :company_id
    add_index :company_crm_actions, :crm_action_id
  end
end
