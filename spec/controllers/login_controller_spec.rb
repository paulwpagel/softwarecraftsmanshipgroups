require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginController do
  
  describe "login" do
    
    before(:each) do
      Admin.stub!(:authenticate).and_return(false)
    end
    
    it "should authenticate on login" do
      Admin.should_receive(:authenticate)
    
      post :login, :username => "Øxnard", :password => "montalvo"
    end
  
    it "should rerender the page on login with bad credentials" do
      post :login, :username => "Øxnard", :password => "montalvo"
    
      response.should render_template('login/login')
    end
  
    it "should assign the error on logging in with bad credentials" do
      post :login, :username => "Øxnard", :password => "montalvo"
    
      assigns[:error].should == "Invalid username and password combination"
    end
  
    it "should redirect to the meeting index page on logging in with good credentials" do
      modmin = mock("Admin",:id => "123")
      Admin.stub!(:authenticate).and_return(true)
      Admin.stub!(:find_by_username).and_return(modmin)
    
      post :login, :username => "Øxnard", :password => "montalvo"
    
      response.should redirect_to(:controller => 'meeting', :action => 'index')
    end
  
    it "should assign the session on login with good credentials" do
      modmin = mock("Admin",:id => "123")
      Admin.stub!(:authenticate).and_return(true)
      Admin.stub!(:find_by_username).and_return(modmin)
    
      post :login, :username => "Øxnard", :password => "montalvo"
    
      session[:admin_id].should == "123"
    end
    
  end
  
  describe "logout" do
    
    it "should clear the session's admin_id on logout" do
      session[:admin_id] = "22"
    
      post :logout
    
      session[:admin_id].should be_nil
    end
  
    it "should redirect to login on logout" do
      post :logout
    
      response.should redirect_to("login/login")
    end
    
  end
  
end
