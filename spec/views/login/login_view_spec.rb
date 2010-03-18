require File.expand_path(File.dirname(__FILE__) + "/../../spec_helper")

describe "Login Views" do
  
  before(:each) do
    render :template => "login/login"
  end
  
  it "should a login_form div" do
    response.should have_tag("div[id=login_form]")
  end
  
  it "should have an input for password" do    
    response.should have_tag("input[type=password][id=password]")
  end
  
  it "should have an input for username" do    
    response.should have_tag("input[type=text][id=username]")
  end
  
  it "should have a submit button" do    
    response.should have_tag("input[type=submit][value=Log in]")
  end
  
end