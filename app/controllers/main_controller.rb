class MainController < ApplicationController
  layout "default"
    
  def rsvp
    @attendee = Attendee.new(:name => scrub(params[:name]), :email => params[:email].strip, :meeting => Meeting.next_meeting,
                             :need_ride => need_ride?(params[:need_ride]))
    @attendee.save
  end
  
  private ######################################################################
  
  def scrub html
    html.gsub(">","&gt;").gsub("<","&lt;")
  end
  
  def need_ride?(checkbox_param='')
    return 'Yes' if checkbox_param == '1'
    return 'No'
  end
  
end
