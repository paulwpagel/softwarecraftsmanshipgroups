require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Meeting do
  
  before(:each) do
    @meeting = Meeting.new
    @title = "Player Hater's Ball"
    @speaker = "The Honorable Octávio Weierstrauss-Rochester Jenkins, IV"
    @description = "Come see the Honorable Octávio Weierstrauss-Rochester Jenkins, known as 'The Honorable Octávio Weierstrauss-Rochester Jenkins,' to his friends, discuss players, haters, and everything in between."
    @time = DateTime.parse("November 20 1902 8 pm")
    @location = "The drawing room of the Eighth Light Observatory on the estates of our benefactor, one Mr. Wodehouse Peanut."

  end
  
  describe "class" do
    
    before(:each) do
      DateTime.stub!(:now).and_return(DateTime.parse("January 1 2000"))
      @mtg1 = Meeting.create(:title => "1980", :description => "1980th new year", 
                             :time => DateTime.now - 20.years, :location => "earth")
      @mtg2 = Meeting.create(:title => "1999", :description => "1999th new year", 
                             :time => DateTime.now - 1.years, :location => "earth")
    end
    
    it "should return the next meeting that has not occurred" do
      @mtg3 = Meeting.create(:title => "2001", :description => "2001st new year", 
                             :time => DateTime.now + 1.years, :location => "earth")
      @mtg4 = Meeting.create(:title => "2020", :description => "2020th new year", 
                             :time => DateTime.now + 20.years, :location => "earth")
    
      Meeting.next_meeting.should == @mtg3
    end
    
    it "should return the latest meeting when no meeting occurs in the future" do
      Meeting.latest_meeting.should == @mtg2
    end
    
  end
  
  it "should have several fields" do
    @meeting.title = @title
    @meeting.speaker = @speaker
    @meeting.description = @description
    @meeting.time = @time
    @meeting.location = @location
    @meeting.save!
    
    @meeting.reload
    
    @meeting.title.should == @title
    @meeting.speaker.should == @speaker
    @meeting.description.should == @description
    @meeting.time.should == @time
    @meeting.location.should == @location
  end
  
  it "should require title" do
    @meeting.description = @description
    @meeting.time = @time
    @meeting.location = @location

    @meeting.should_not be_valid
    @meeting.error_messages.should == ["Title can't be blank"]
  end
  
  it "should require description" do
    @meeting.title = @title
    @meeting.time = @time
    @meeting.location = @location
    
    @meeting.should_not be_valid
    @meeting.error_messages.should == ["Description can't be blank"]

  end
  
  it "should require time" do
    @meeting.title = @title
    @meeting.description = @description
    @meeting.location = @location
    
    @meeting.should_not be_valid
    @meeting.error_messages.should == ["Time can't be blank"]
  end
  
  it "should require location" do
    @meeting.title = @title
    @meeting.description = @description
    @meeting.time = @time
    
    @meeting.should_not be_valid
    @meeting.error_messages.should == ["Location can't be blank"]
  end
  
  it "should not require a speaker" do
    @meeting.title = @title
    @meeting.description = @description
    @meeting.time = @time
    @meeting.location = @location
    
    @meeting.should be_valid
  end
  
  
  it "should validate" do
    @meeting.title = @title
    @meeting.description = @description
    @meeting.location = @location
    @meeting.time = @time
    
    @meeting.should be_valid
    @meeting.error_messages.should == []
  end
  
  describe "members" do
    
    before(:each) do
      @mtg = Meeting.create(:title => "mtg", :speaker => "me", :description => "fun", :location => "somewhere", :time => DateTime.parse("December 21 2012"))
      @attendee = Attendee.create(:name => "ulysses", :email => "titan@theogeny.com")
      @mtg.attendees << @attendee
      @mtg.save!
    end
    
    it "should have attendees" do
      @mtg.reload
    
      @mtg.attendees.should include(@attendee)
    end
    
    describe "date" do

      it "should return the date, by itself" do
        @mtg.reload
    
        @mtg.date.should == Date.parse("December 21, 2012")
      end
    
      it "should return the date, prettily" do
        @mtg.pretty_date.should == "Friday, December 21, 2012"
      end
    
      it "should set the date" do
        @mtg.date = "November 19 1999"
      
        @mtg.save!
        @mtg.reload
      
        @mtg.date.should == Date.parse("November 19 1999")
      end
    
      it "should set the date without changing the time_of_day" do
        @mtg.time_of_day = {:hour => "2", :minute => "44", :delimiter => "PM"}
        @mtg.date = "November 19 1999"
      
        @mtg.save!
      
        @mtg.date.should == Date.parse("November 19 1999")
        @mtg.time_of_day.should == "2:44 PM"
      end
      
      it "should create with date rather than time" do
        lambda do
          @mtg = Meeting.create(:title => "mtg", :speaker => "me", :description => "fun", :location => "somewhere", 
                                      :date => "December 21 2012") 
        end.should_not raise_error
      end
      
      it "should return the month of the meeting" do
        @mtg.month.should == 12
      end
      
      it "should return the day of the meeting" do
        @mtg.day.should == 21
      end
      
      it "should return the year of the meeting" do
        @mtg.year.should == 2012
      end
      # TODO - DSA - Pass the DateTime ArgumentError to the ActiveRecord Validator instead of failing silently
      # it "should handle date format errors" do
      #   mtg = Meeting.create(:title => "mtg", :speaker => "me", :description => "fun", :location => "somewhere", :date => "Decebuary 74rd")
      # 
      #   mtg.date = "Decebuary 74rd"
      #   
      #   mtg.should_not be_valid
      #   mtg.error_messages.should == ["Date format invalid"]
      # end
      
    end
    
    describe "time_of_day" do
      
      it "should return midnight by default" do
        @mtg.time_of_day.should == "12:00 AM"
      end
      
      it "should set the time_of_day" do
        @mtg.time_of_day = {:hour => "2", :minute => "44", :delimiter => "PM"}
        
        @mtg.save!
        
        @mtg.time_of_day.should == "2:44 PM"
      end
      
      it "should set the time_of_day without changing the date" do
        @mtg.time_of_day = {:hour => "2", :minute => "44", :delimiter => "PM"}
        
        @mtg.save!
        
        @mtg.date.should == Date.parse("December 21, 2012")
        @mtg.time_of_day.should == "2:44 PM"
      end
      
      it "should create with date and time_of_day" do
        @mtg = Meeting.create(:title => "mtg", :speaker => "me", :description => "fun", :location => "somewhere", 
                              :date => "December 21 2012", :time_of_day => {:hour => "2", :minute => "44", :delimiter => "PM"})
        @mtg.reload
        
        @mtg.date.should == Date.parse("December 21, 2012")
        @mtg.time_of_day.should == "2:44 PM"
      end
      
    end
      
  end
  
end
