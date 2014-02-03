class CreateCrmcomments < ActiveRecord::Migration
  def change
    create_table :crmcomments do |t|
      t.references :user
      t.datetime :dtime
      t.text :comment
      t.references :commentable, polymorphic: true
    end
    add_index :crmcomments, :user_id
  end
end
