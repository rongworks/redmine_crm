class AddDetailsToAttachedDocuments < ActiveRecord::Migration
  def change
    add_column :attached_documents, :description, :string, default: ''
    add_column :attached_documents, :last_update, :datetime
    add_column :attached_documents, :locked, :boolean, default: false
  end
end