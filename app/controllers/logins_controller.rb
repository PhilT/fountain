class LoginsController < ApplicationController
  def new
    @heading = 'Admin Login'
  end

  def create
    @heading = 'Admin Login'
    @password = params[:password]

    if Login.valid?(@password)
      session[:admin] = true
      flash[:notice] = 'Login was successful'
      redirect_to root_url
    else
      flash[:error] = "Invalid Password"
      render :action => "new"
    end
  end

end
