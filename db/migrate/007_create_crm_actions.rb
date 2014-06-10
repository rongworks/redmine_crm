class CreateCrmActions < ActiveRecord::Migration
  def change
    create_table :crm_actions do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :end_date
      t.boolean :done
    end
  end
end
