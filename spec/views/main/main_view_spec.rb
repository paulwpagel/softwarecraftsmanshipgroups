require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")
      
describe "Main Views" do
  
  describe "index" do 
    before(:each) do
      @mocktendees = mock("attendees", :find => [])
      @mockting = mock("meeting", :title => nil, :speaker => nil, :description => nil, :pretty_date => nil, :year => 1234,
                                  :time_of_day => nil, :location => nil, :day => nil, :attendees => @mocktendees, :month => 1)
      Meeting.stub!(:next_meeting).and_return(@mockting)
    end
  
    describe "calendar" do
    
      it "should call the current year" do
        @mockting.should_receive(:year).and_return(123)
      
        render :template => 'main/index'
      end
    
    end
  
    describe "rsvp form" do
    
      before(:each) do
        render :template => 'main/index'
      end
    
      it "should have a text field for name" do    
        response.body.should include("name")
        response.body.should have_tag('input[type=text][id=name]')
      end
    
      it "should have a text field for email" do
        response.body.should include("email")
        response.body.should have_tag('input[type=text][id=email]')
      end
    
      it "should have a checkbox for need_ride" do
        response.body.should include("Need Pickup?")
        response.body.should have_tag('input[type=checkbox][id=need_ride]')
      end
    
      it "should have a submit button" do
        response.body.should have_tag('input[type=submit][value=RSVP]')
      end

    end
  
    describe "next meeting or lack thereof" do
    
      before(:each) do
        @mockting.stub!(:title).and_return("next_meeting")
      
        @mockting2 = mock("meeting", :title => "latest_meeting", :speaker => nil, :description => nil, :pretty_date => nil,
                                    :year => 1234, :time_of_day => nil, :location => nil, :day => nil, 
                                    :attendees => @mocktendees, :month => 1)
      end
    
      it "should next_meeting when it exists" do
        Meeting.should_receive(:next_meeting).at_least(:once).and_return(@mockting)
      
        render :template => 'main/index'
      
        response.body.should include("next_meeting")
      end
    
      it "should display latest meeting when there isn't a next_meeting scheduled" do
        Meeting.stub!(:next_meeting).and_return(nil)
        Meeting.should_receive(:latest_meeting).and_return(@mockting2)
      
        render :template => 'main/index'
      
        response.body.should include("latest_meeting")
      end
    
    end
    
  end
  

 describe "rsvp" do
   
   before(:each) do
     @mocktendee = mock("attendee", :errors => @morrors, :name => 'Rambo', :error_messages => ["EPIC FAIL"])
     assigns[:attendee] = @mocktendee
   end
   
   it "should replace form_errors on rsvp for a valid attendee" do
     @mocktendee.stub!(:error_messages).and_return([])
     render :template => "main/rsvp"
   
     response.should have_rjs(:replace_html, "form_errors")
     response.body.should include("Thanks for your interest. See you there!")      
   end
 
   it "should replace form_errors on rsvp for an invalid attendee" do    
     render :template => "main/rsvp"
   
     response.should have_rjs(:replace_html, "form_errors")
     response.body.should include("EPIC FAIL")
   end
 
   it "should insert HTML on rsvp for valid attendees" do
     @mocktendee.stub!(:error_messages).and_return([])
     
     render :template => "main/rsvp"

     response.should have_rjs(:insert_html)
   end
   
 end
  
end