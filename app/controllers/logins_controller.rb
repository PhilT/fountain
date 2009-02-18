class LoginsController < ApplicationController
  def new
  end

  def create
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
