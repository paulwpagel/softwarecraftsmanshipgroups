class LoginController < ApplicationController
  
  filter_parameter_logging :password
  layout "default"
  
  def login
    if Admin.authenticate(params[:username], params[:password])
      admin = Admin.find_by_username(params[:username])
      session[:admin_id] = admin.id
      redirect_to(:controller => 'meeting')
    else
      @error = "Invalid username and password combination"
    end
  end
  
  def logout
    session[:admin_id] = nil
    redirect_to(:controller => 'login', :action => 'login')
  end

end
