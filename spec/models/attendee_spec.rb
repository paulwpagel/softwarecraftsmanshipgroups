require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Attendee do
  before(:each) do
    @attendee = Attendee.new
  end
  
  it "should have some fields" do
    @attendee.name = "test"
    @attendee.email = "test@test.com"
    @attendee.need_ride = "Yes"
    
    @attendee.save!
    @attendee.reload
    
    @attendee.name.should == "test"
    @attendee.email.should == "test@test.com"
    @attendee.need_ride.should == "Yes"
  end
  
  it "should require a name" do
    @attendee.email = "asdf@example.com"
    
    @attendee.should_not be_valid
    @attendee.errors.full_messages.should == ["Name is missing. If you don't provide your name, we won't know who you are."]
  end
  
  describe Attendee, "with valid name" do
    before(:each) do
      @attendee.name = "somethin'"
    end

    it "should require an email address" do    
      @attendee.should_not be_valid #also satisfied by formatter test
      @attendee.errors.full_messages.should == ["Email is missing. Please provide an email so we can notify you if the plans should change."]
    end

    it "should not accept malformed email addresses" do
      @attendee.email = "nøñSêns3"
    
      @attendee.should_not be_valid
      @attendee.errors.full_messages.should == ["Email is not in a valid format!"]
    end
  
    it "should accept properly formatted email addresses" do
      @attendee.email = "something@example.com"
    
      @attendee.should be_valid
    end
  end
  
  describe "meetings" do
    
    before(:each) do
      @meeting_one = Meeting.create(:title => "title",:description => "desc", :time => DateTime.now, :location => "here")
      @meeting_two = Meeting.create(:title => "title2",:description => "desc2", :time => DateTime.now, :location => "here2")
    end

    it "should not accept duplicate emails for the same meeting" do
      attendee_one = Attendee.create(:name => 'Admiral Akbar', :email => "its@trap.com", :meeting => @meeting_one)
      attendee_two = Attendee.new(:name => 'Darth Vader', :email => "its@trap.com", :meeting => @meeting_one)
    
      attendee_two.should_not be_valid
      attendee_two.errors.full_messages.should == ["Email is already on the list for this meeting!"]
    end
  
    it "should not accept duplicate name for the same meeting" do
      attendee_one = Attendee.create(:name => 'Mister Spock', :email => "its@trap.com", :meeting => @meeting_one)
      attendee_two = Attendee.new(:name => 'Mister Spock', :email => "evil.twin@mirror.universe", :meeting => @meeting_one)
    
      attendee_two.should_not be_valid
      attendee_two.errors.full_messages.should == ["Name is already on the list for this meeting!"]
    end
  
    it "should not accept duplicate emails for the same meeting" do
      attendee_one = Attendee.create(:name => 'Admiral Akbar', :email => "its@trap.com", :meeting => @meeting_one)
      attendee_two = Attendee.new(:name => 'Darth Vader', :email => "its@trap.com", :meeting => @meeting_two)
    
      attendee_two.should be_valid
    end
  
    it "should not accept duplicate name for the same meeting" do
      attendee_one = Attendee.create(:name => 'Mister Spock', :email => "its@trap.com", :meeting => @meeting_one)
      attendee_two = Attendee.new(:name => 'Mister Spock', :email => "evil.twin@mirror.universe", :meeting => @meeting_two)
    
      attendee_two.should be_valid
    end
    
    it "should have a meeting" do
      @attendee.email = "asdf@example.com"
      @attendee.name = "asdf"
      @meeting_one.attendees << @attendee
      @meeting_one.save!
    
      @attendee.meeting.should === @meeting_one
    end
    
  end
  
  it "should return error_messages for an invalid attendee" do
    @attendee_one = Attendee.create(:name => 'Mister Spock', :email => "its@trap.com")
    @attendee_two = Attendee.new(:name => 'Mister Spock')
    
    @attendee_two.should_not be_valid
    @attendee_two.error_messages.size.should == 2
    @attendee_two.error_messages.should include("Name is already on the list for this meeting!")
    @attendee_two.error_messages.should include("Email is missing. Please provide an email so we can notify you if the plans should change.")
  end
  
  it "should return an empty array for error_messages for a valid attendee" do
    @attendee = Attendee.create(:name => 'Mister Spock', :email => "its@trap.com")
    
    @attendee.should be_valid
    @attendee.error_messages.should == []
  end
  
end
