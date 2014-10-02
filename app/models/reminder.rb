class Reminder < ActiveRecord::Base
  unloadable
  PUBLIC_URL = Rails.root
  belongs_to :remindable, polymorphic:true

  validates_presence_of :remindable, :due, :title
  before_save :set_time

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = self.begin.strftime("%Y%m%dT%H%M%S")
    event.dtend = self.due.strftime("%Y%m%dT%H%M%S")
    event.summary = self.title
    event.description = self.summary
    event.location = 'Here !'
    event.ip_class = 'PUBLIC'
    event.created = self[:created_at]
    event.last_modified = self[:updated_at]
    event.uid = event.url = "#{PUBLIC_URL}events/#{self.id}"
    event.alarm do |a|
      a.action  = 'DISPLAY'
      a.summary = self.title
      a.trigger = "-PT15M" # 15 minutes before
    end
    event
  end

  def overdue?
    closed? ? false : Time.now > due
  end

  private
  def set_time
    self.due = DateTime.new(self.due.year, self.due.month, self.due.day, 9, 15, 0)
    self.begin = DateTime.new(self.begin.year, self.begin.month, self.begin.day, 9, 15, 0)
  end
end
