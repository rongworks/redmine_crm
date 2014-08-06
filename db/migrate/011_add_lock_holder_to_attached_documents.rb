class AddLockHolderToAttachedDocuments < ActiveRecord::Migration
  def change
    add_column :attached_documents, :lock_holder_id, :integer
    add_index :attached_documents, :lock_holder_id
  end
end