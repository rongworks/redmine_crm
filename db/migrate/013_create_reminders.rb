class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.string :title
      t.text :content
      t.text :summary
      t.datetime :begin
      t.datetime :due
      t.string :location
      t.string :organizer_name
      t.string :organizer_mail
      t.references :remindable, polymorphic: true
    end
  end
end
