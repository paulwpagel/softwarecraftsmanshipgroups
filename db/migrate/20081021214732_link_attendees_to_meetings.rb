class LinkAttendeesToMeetings < ActiveRecord::Migration
  def self.up
    Attendee.find(:all).each do |att|
      rsvp_date = att.created_at
      first_meeting_after_rsvp = Meeting.find(:first, :conditions => [ "time >= :time", {:time => rsvp_date }], :order => "time ASC")
      att.meeting = first_meeting_after_rsvp unless att.meeting
      if att.valid?
        att.save!
      else 
        att.name += rand(10000).to_s
        att.email += rand(10000).to_s unless att.valid?
        att.save!
      end
    end
  end

  def self.down
  end
  
end
