class CrmRemindersController < ApplicationController
  unloadable
  include SharedModule
  before_filter :find_reminder, :find_remindable, only: [:show, :edit, :destroy, :close]
  layout 'companies_layout'

  def index
    @crm_reminders = CrmReminder.order('crm_reminders.due DESC').all
  end

  def new
    @crm_reminder = CrmReminder.new
  end

  def create
    @crm_reminder = CrmReminder.new(params[:crm_reminder])
    if params[:due_time]
      change_date(@crm_reminder.due, params[:due_time])
    end
    if params[:begin_time]
      change_date(@crm_reminder.begin, params[:begin_time])
    end
    if @crm_reminder.begin.nil?
      @crm_reminder.begin = @crm_reminder.due
    end
    respond_to do |format|
      if @crm_reminder.save
        format.html {redirect_to reminders_path, notice: t(:save_successful)}
        format.js
      else
        format.html{render :new}
        format.js
      end
    end

  end

  def edit
  end

  def show
    respond_to do |wants|
      wants.html
      wants.ics do
        calendar = Icalendar::Calendar.new
        calendar.add_event(@crm_reminder.to_ics)
        calendar.publish
        render :text => calendar.to_ical
      end
    end
  end

  def destroy
    @crm_reminder.destroy
    redirect_to :back
  end

  def close
    @crm_reminder.closed=true
    @crm_reminder.save
    redirect_to :back
  end

  private

  def change_date(date, param)
    time = Time.parse(param)
    date.change({hours: time.hours, minutes: time.minutes})
  end

  def find_reminder
    @crm_reminder = CrmReminder.find(params[:id])
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
