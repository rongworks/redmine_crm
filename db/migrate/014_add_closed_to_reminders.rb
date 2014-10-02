class AddClosedToReminders < ActiveRecord::Migration
  def change
    add_column :reminders, :closed, :boolean
  end
end
