class RemindersController < ApplicationController
  unloadable
  include SharedModule
  before_filter :find_reminder, :find_remindable, only: [:show, :edit, :destroy]
  layout 'companies_layout'

  def index
    @reminders = Reminder.order('reminders.due DESC').all
  end

  def new
    @reminder = Reminder.new
  end

  def create
    @reminder = Reminder.new(params[:reminder])
    if params[:due_time]
      change_date(@reminder.due, params[:due_time])
    end
    if params[:begin_time]
      change_date(@reminder.begin, params[:begin_time])
    end
    if @reminder.begin.nil?
      @reminder.begin = @reminder.due
    end
    if @reminder.save
      redirect_to reminders_path, notice: t(:save_successful)
    else
      render :new
    end

  end

  def edit
  end

  def show
    respond_to do |wants|
      wants.html
      wants.ics do
        calendar = Icalendar::Calendar.new
        calendar.add_event(@reminder.to_ics)
        calendar.publish
        render :text => calendar.to_ical
      end
    end
  end

  def destroy
    @reminder.destroy
    redirect_to :back
  end

  private

  def change_date(date, param)
    time = Time.parse(param)
    date.change({hours: time.hours, minutes: time.minutes})
  end

  def find_reminder
    @reminder = Reminder.find(params[:id])
  end

  def find_remindable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @remindable = $1.classify.constantize.find(value)
        return @remindable
      end
    end
    nil
  end
end
