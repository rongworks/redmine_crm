class CreateAttachedDocuments < ActiveRecord::Migration
  def change
    create_table :attached_documents do |t|
      t.string :file
      t.integer :container_id
      t.string :container_type
      t.string :filename
      t.string :content_type
      t.integer :size
      t.references :user
    end
    add_index :attached_documents, :user_id
  end
end
