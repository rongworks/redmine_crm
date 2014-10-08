class RenameRemindersToCrmReminders < ActiveRecord::Migration
  def change
    rename_table :reminders, :crm_reminders
  end
end