require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

#required to sate deprecation whinytext for RSpec 1.14
require 'meeting_helper'
include MeetingHelper

describe MeetingHelper do
  
  describe "minutes_in_intervals_of" do
    
    it "should return the numbers 0-59 if the interval is 1" do
      mins = minutes_in_intervals_of 1
      
      mins.size.should == 60
      mins.uniq.size.should == 60
      mins.min.should == "00"
      mins.max.should == "59"
    end
    
    it "should return the even numbers 0-59 if the interval is 2" do
      mins = minutes_in_intervals_of 2
      
      mins.size.should == 30
      mins.uniq.size.should == 30
      mins.min.should == "00"
      mins.max.should == "58"
    end
    
    it "should return the multiples of 7 in 0-59 if the interval is 7" do
      # 0,7,14,21,28,35,42,49,56
      mins = minutes_in_intervals_of 7
      
      mins.size.should == 9
      mins.max.should == "56"
    end
    
    it "should always return two-character strings" do
      mins = minutes_in_intervals_of 1
      
      mins.should include("01")
      mins.should_not include("1")
      mins.should_not include(1)
    end
    
  end  

end