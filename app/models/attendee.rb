EMAIL_FORMAT =  Regexp.new(/^([^@\s]+)@((?:[-+a-z0-9]+\.)+[-a-z0-9]{2,})$/i)
class Attendee < ActiveRecord::Base
  validates_presence_of     :email,
                            :message => "is missing. Please provide an email so we can notify you if the plans should change."
  validates_uniqueness_of   :email,       :message => "is already on the list for this meeting!",     :scope => :meeting_id
  validates_format_of       :email,       :with => EMAIL_FORMAT,    :on => :save,   :if => Proc.new{|att| !att.email.blank?},
                            :message => "is not in a valid format!"
  validates_presence_of     :name,        :message => "is missing. If you don't provide your name, we won't know who you are."
  validates_uniqueness_of   :name,        :message => "is already on the list for this meeting!",      :scope => :meeting_id
  belongs_to                :meeting
  
  def error_messages
    errors.full_messages
  end
  
end
