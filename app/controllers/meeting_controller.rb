class MeetingController < ApplicationController

  before_filter :require_login
  layout "default"
  
  def index
    @meetings = Meeting.find(:all)
  end
  
  def create
    mtg = Meeting.new(:location => params[:location], :title => params[:title], :description => params[:description][:text], 
                   :date => params[:date], :time_of_day => params[:time_of_day], :speaker => params[:speaker])
    mtg.save! if mtg.valid?
                  
    redirect_to(:controller => 'meeting')
  end
    
  def view_details
    find_meeting_from_params
  end
  
  def hide_details
    find_meeting_from_params
  end
  
  private################################################################
  
  def find_meeting_from_params
    @meeting = Meeting.find(params[:meeting_id])
  end
  
  def require_login
    unless (Admin.exists?(session[:admin_id]))
      redirect_to(:controller => 'login',:action => 'login')
    end
  end
  
end
