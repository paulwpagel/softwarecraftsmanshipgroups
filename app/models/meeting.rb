class Meeting < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :time
  validates_presence_of :location
  has_many :attendees
  
  def self.next_meeting
    next_meeting = Meeting.find(:first, :conditions => [ "time >= :time", {:time => DateTime.now}], :order => "time ASC")
    return next_meeting if next_meeting
  end
  
  def self.latest_meeting
    return Meeting.find(:last, :order => "time ASC")
  end
  
  def date
    time.to_date
  end
  
  def date=(new_date)
      seconds_since_midnight = self.time ? self.time.seconds_since_midnight : 0
      self.time = DateTime.parse(new_date) + seconds_since_midnight.seconds
  end
  
  def pretty_date
    return date.strftime("%A, %B %d, %Y")
  end
  
  def time_of_day
    return "#{hour}:#{minute} #{delimiter}"
  end
  
  def time_of_day=(new_time)
    unless new_time[:delimiter] == 'PM'
      self.time = DateTime.civil(time.year, time.month, time.day, new_time[:hour].to_i, new_time[:minute].to_i)
    else
      self.time = DateTime.civil(time.year, time.month, time.day, new_time[:hour].to_i + 12, new_time[:minute].to_i)
    end
  end
  
  def month
    time.month
  end
  
  def day
    time.day
  end
  
  def year
    time.year
  end
  
  def error_messages
    errors.full_messages
  end  
  
  private########################################################################
  
  def hour
    hr = time.hour
    return ((hr-1)%12 + 1)
  end
  
  def minute
    return time.min if time.min > 9
    return "0#{time.min}"
  end
  
  def delimiter
    return "AM" if time.hour < 12
    return "PM"
  end
  
end
