class AddRideToAttendees < ActiveRecord::Migration
  def self.up
    add_column  :attendees, :need_ride, :string
  end

  def self.down
    remove_column  :attendees, :need_ride
  end
end

