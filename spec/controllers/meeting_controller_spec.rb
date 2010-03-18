require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MeetingController do
  
  before(:each) do
    Admin.destroy_all
    Meeting.destroy_all
  end
  
  describe "authentication behavior" do
    
    before(:each) do
      @admin = Admin.create(:username => "thomas", :password => "tankengine")
    end
    
    it "should redirect to login when admin_id is nil" do
      session[:admin_id] = nil
    
      post :index
    
      response.should redirect_to(:controller => 'login', :action => 'login')
    end
  
    it "should not redirect to login when admin_id refers to an existing admin" do
      session[:admin_id] = @admin.id
    
      post :index
    
      response.should render_template('meeting/index')
    end
  
    it "should redirect to login when admin_id refers to a nonexistant admin" do
      session[:admin_id] = @admin.id
      @admin.destroy
    
      post :index
    
      response.should redirect_to(:controller => 'login', :action => 'login')
    end
    
  end
  
  describe "logged in" do
    
    before(:each) do
      @admin = Admin.create(:username => "thomas", :password => "tankengine")
      session[:admin_id] = @admin.id
    end
    
    describe "index" do    
      it "should find all meetings" do
        Meeting.should_receive(:find).with(:all)
      
        post :index
      end
    
      it "should assign meetings" do
        mocktings = mock("meetings")
        Meeting.stub!(:find).and_return(mocktings)
      
        post :index
      
        assigns[:meetings].should == mocktings
      end
      
    end
  
    describe "create" do
      
      before(:each) do
        @mockting = mock("meeting", :save! => nil, :valid? => true)
        Meeting.stub!(:save!)
      end
      
      it "should instantiate a meeting" do
        Meeting.should_receive(:new).with(:location => 'here', :title => 'fun', :description => 'awesome', 
                                          :date => "December 21, 2012", :speaker => nil, :time_of_day => nil).and_return(@mockting)
                                          
        post :create, :location => 'here', :title => 'fun', :description => {:text =>'awesome'}, :date => "December 21, 2012"
      end
      
      it "should save a valid meeting" do
        Meeting.should_receive(:new).and_return(@mockting)
        @mockting.should_receive(:save!)
        
        post :create, :location => 'here', :title => 'fun', :description => {:text =>'awesome'}, :date => "December 21, 2012"
      end
      
      it "should not save an invalid meeting" do
        Meeting.stub!(:new).and_return(@mockting)
        @mockting.stub!(:valid?).and_return(false)
        Meeting.should_not_receive(:save!)
        
        post :create, :location => 'here', :title => 'fun', :description => {:text =>'awesome'}, :date => "December 21, 2012"
      end
      
    end
    
    describe "view_details" do
      
      it "should find the meeting with the id passed in to the param" do
        Meeting.should_receive(:find).with("a123")
        
        post :view_details, :meeting_id => "a123"
      end
      
      it "should assign meeting the meeting with id param meeting_id" do
        mockting = mock("meeting", :id => "a123")
        Meeting.stub!(:find).and_return(mockting)
        
        post :view_details, :meeting_id => "a123"
        
        assigns[:meeting].id.should == "a123"
      end
      
    end
    
    describe "hide_details" do
      
      it "should find the meeting with the id passed in to the param" do
        Meeting.should_receive(:find).with("a123")
        
        post :hide_details, :meeting_id => "a123"
      end
      
      it "should assign meeting the meeting with id param meeting_id" do
        mockting = mock("meeting", :id => "a123")
        Meeting.stub!(:find).and_return(mockting)
        
        post :hide_details, :meeting_id => "a123"
        
        assigns[:meeting].id.should == "a123"
      end
      
    end
    
  end
  
end
