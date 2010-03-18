require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MainController do
  
  describe "rsvp" do
    
    before(:each) do
      @mockting = mock("Meeting")
      @mocktendee = mock("attendee", :save => nil, :meeting= => nil)
      Attendee.stub!(:new).and_return(@mocktendee)
    end
    
    it "should assign @attendee a new attendee" do
      post :rsvp, :name => "ghidora", :email => "king.of@uter.space"
    
      assigns[:attendee].should == @mocktendee
    end
          
    it "should create a new attendee" do
      Meeting.stub!(:next_meeting).and_return(@mockting)
      Attendee.should_receive(:new).with(:name => 'ghidora',:email => "king.of@uter.space", :meeting => @mockting, 
                                         :need_ride => 'No').and_return(@mocktendee)

      post :rsvp, :name => "ghidora", :email => "king.of@uter.space"
    end
  
    it "should save an attendee" do
      @mocktendee.should_receive(:save)
      
      post :rsvp, :name => "ghidora", :email => "king.of@uter.space"
    end

    it "should submit yes for need_ride when the box is checked" do
      Meeting.stub!(:next_meeting).and_return(@mockting)
      Attendee.should_receive(:new).with(:name => 'ghidora',:email => "king.of@uter.space", :meeting => @mockting, :need_ride => 'Yes').and_return(@mocktendee)

      post :rsvp, :name => "ghidora", :email => "king.of@uter.space", :need_ride => '1'
    end
    
    it "should submit no for need_ride otherwise" do
      Meeting.stub!(:next_meeting).and_return(@mockting)
      Attendee.should_receive(:new).with(:name => 'ghidora',:email => "king.of@uter.space", :meeting => @mockting, :need_ride => 'No').and_return(@mocktendee)

      post :rsvp, :name => "ghidora", :email => "king.of@uter.space"
    end
    
    describe "modify inputs" do
      
      before(:each) do
        @mocktendee = mock("attendee", :save => nil)
      end
      
      it "should scrub html from the name and email" do
        Attendee.should_receive(:new).with(:name => "&lt;l337&gt;&lt;/h4x0r&gt;",:email => "king.ofm@ms.basement", 
                                           :meeting => nil, :need_ride => 'No').and_return(@mocktendee)
      
        post :rsvp, :name => "<l337></h4x0r>", :email => "king.ofm@ms.basement"
      end
    
      it "should strip spaces out of email addresses" do
        Attendee.should_receive(:new).with(:name => "ghidora",:email => "king.of@uter.space", 
                                           :meeting => nil, :need_ride => 'No').and_return(@mocktendee)
      
        post :rsvp, :name => "ghidora", :email => "          king.of@uter.space        "
      end
    
    end
    
    describe "meeting" do
      
      before(:each) do
        @mockting = mock("meeting")
        Meeting.stub!(:next_meeting).and_return(@mockting)
      end
      
      it "should not set an invalid attendee's meeting" do
        @mocktendee.stub!(:valid?).and_return(false)
        @mocktendee.should_not_receive(:meeting=)
      
        post :rsvp, :name => "ghidora", :email => "king.of@uter.space"
      end
      
    end
    
  end
  
end
