require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Meeting Views" do
  
  before(:each) do
    mtg = mock(Meeting, :title => 'end_of_the_world', :date => DateTime.parse("December 21 2012"), 
                        :pretty_date => "Friday, December 21, 2012", :id => "a123")
    mtg2 = mock(Meeting, :title => 'after_party_of_the_world', :date => DateTime.parse("December 22 2012"), 
                         :pretty_date => "Saturday, December 22, 2012", :id => "b456")
    assigns[:meetings] = [mtg, mtg2]
  end
  
  describe "index" do
    
    before(:each) do
      render :template => 'meeting/index'
    end
    
    it "should have a meeting list div" do      
      response.should have_tag('div[id=meeting_list]')
    end
    
    it "should display the meeting title" do            
      response.body.should include('end_of_the_world')
      response.body.should include('after_party_of_the_world')      
    end    
    
    it "should display the meeting date" do
      response.body.should include('Friday, December 21, 2012')
      response.body.should include('Saturday, December 22, 2012')
    end
    
    it "should have a logout link" do
      response.should have_tag('a[id=logout]')
    end

    it "should have a new meeting link" do
      response.should have_tag('a[id=new_meeting]')
    end
    
    it "should have a new_meeting_form div" do
      response.should have_tag('div[id=new_meeting_div]')
    end
    
    it "should have a view_details_for_meeting_(id) link for each meeting" do
      response.should have_tag('a[id=view_details_for_meeting_a123]')
      response.should have_tag('a[id=view_details_for_meeting_b456]')
    end
    
    it "should have a meeting_(id)_details div for each meeting" do
      response.should have_tag('div[id=meeting_a123_details]')
      response.should have_tag('div[id=meeting_b456_details]')
    end
    
    it "should have a toggle_(id)_details div for each meeting" do
      response.should have_tag('div[id=toggle_a123_details]')
      response.should have_tag('div[id=toggle_b456_details]')
    end
    
  end
  
  describe "with meeting assigned" do
    
    before(:each) do
      mockting = mock("meeting", :id => "a123", :title => "titl_a123", :description => "desc_a123", :time => "time_a123", 
                                 :location => "loca_a123", :speaker => "spkr_a123", :pretty_date => "fdat_a123", 
                                 :time_of_day => "time_a123")
      assigns[:meeting] = mockting
    end
    
    describe "view_details" do
      
      before(:each) do
        assigns[:meeting].stub!(:attendees).and_return([])
        render :template => 'meeting/view_details'
      end
      
      it "should replace meeting_(id)_details" do
        response.should have_rjs(:replace_html, "meeting_a123_details")
      end  
  
      it "should replace toggle_(id)_details" do
        response.should have_rjs(:replace_html, "toggle_a123_details")
      end
    
    end
  
    describe "hide_details" do
      
      before(:each) do
        render :template => 'meeting/hide_details'
      end
    
      it "should replace meeting_(id)_details" do      
        response.should have_rjs(:replace_html, "meeting_a123_details")
      end  
  
      it "should replace toggle_(id)_details" do
        response.should have_rjs(:replace_html, "toggle_a123_details")
      end
    
    end
    
  end
  
  describe "meeting_details" do
    
    before(:each) do
      @mockting = mock("meeting", :id => "a123", :description => "desc_a123", :speaker => "spkr_a123", 
                                 :location => "loca_a123", :time_of_day => "time_a123", :attendees => [])
    end
    
    it "should display meeting details" do      
      render :partial => 'meeting/details', :locals => {:meeting => @mockting}
      
      response.body.should include("Description")
      response.body.should include("Location")
      response.body.should include("Speaker")
      response.body.should include("Time")      
      response.body.should include("desc_a123")
      response.body.should include("loca_a123")
      response.body.should include("spkr_a123")
      response.body.should include("time_a123")
    end
    
    it "should display attendees" do
      attendee_one = mock("attendee", :name => 'Sacho McPugginabalastein', :email => "ev@re.st", :need_ride => 'Yes')
      attendee_two = mock("attendee", :name => 'Hieronymous Pheasant', :email => "hp@pheas.ant", :need_ride => 'Daily')
      @mockting.attendees << attendee_one << attendee_two
      
      render :partial => 'meeting/details', :locals => {:meeting => @mockting}

      response.body.should include("Name")
      response.body.should include("Email")
      response.body.should include("Needs Pickup?")
      response.body.should include("Sacho McPugginabalastein")
      response.body.should include("Hieronymous Pheasant")
      response.body.should include("ev@re.st")
      response.body.should include("hp@pheas.ant")
      response.body.should include("Yes")
      response.body.should include("Daily")
    end
    
    it "should not include speaker when there is no speaker" do
      @mockting.stub!(:speaker).and_return(nil)
      
      render :partial => 'meeting/details', :locals => {:meeting => @mockting}
      
      response.body.should_not include("Speaker")
      response.body.should_not include("spkr_a123")
    end
    
  end
  
  describe "new_meeting" do
    
    it "should replace new_meeting_form" do
      render :template => 'meeting/new_meeting'
      
      response.should have_rjs(:replace_html, "new_meeting_div")
    end
    
  end
  
  describe "new_meeting_form" do
    
    before(:each) do
      render :partial => 'meeting/new_meeting_form'
    end
    
    it "should have a field for title" do
      response.should have_tag("input[type=text][id=title]")
    end
    
    it "should have a field for description" do
      response.should have_tag("textarea[id=description_text]")
    end
    
    it "should have a field for speaker" do
      response.should have_tag("input[type=text][id=speaker]")
    end
    
    it "should have a field for location" do
      response.should have_tag("input[type=text][id=location]")
    end
    
    it "should have a field for date" do
      response.should have_tag("input[type=text][id=date]")
    end
    
    it "should have a dropdown for hour" do
      response.should have_tag("select[id=time_of_day_hour]")
    end
    
    it "should have a dropdown for minute" do
      response.should have_tag("select[id=time_of_day_minute]")
    end
    
    it "should have a dropdown for delimiter" do
      response.should have_tag("select[id=time_of_day_delimiter]")
    end
    
    it "should have a create button" do
      response.should have_tag("input[type=submit][value=Create]")
    end

  end
  
end