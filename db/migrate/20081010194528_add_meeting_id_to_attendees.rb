class AddMeetingIdToAttendees < ActiveRecord::Migration
  def self.up
    add_column  :attendees, :meeting_id, :integer
  end

  def self.down
    remove_column  :attendees, :meeting_id
  end
end