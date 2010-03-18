require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Admin do
  
  before(:each) do
    @admin = Admin.new
    @admin.username = "tychus"
    @admin.password = "findlay"
    @admin.save!
  end

  it "should save a username and password" do
    @admin.reload

    @admin.username.should == "tychus"
    @admin.password.should_not be_nil 
  end

  it "should encrypt the password" do
    @admin.reload

    @admin.password.should == Admin.encrypt("findlay")
  end

  describe "class" do
    
    it "should call hexdigest on encrypt" do
      Digest::SHA1.should_receive(:hexdigest).with("findlay")
    
      Admin.encrypt("findlay")
    end
  
    it "should authenticate false if the user does not exist" do    
      Admin.authenticate("baduser", "irrelevant").should == false
    end
  
    it "should authenticate false if the password does not match the given user" do
      Admin.authenticate("tychus", "tassadar").should == false
    end
  
    it "should authenticate true if the user exists and the password matches" do
      Admin.authenticate("tychus", "findlay").should == true
    end
  
  end
end
