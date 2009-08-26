class LoginsController < ApplicationController
  def new
    @heading = 'Access Login'
  end

  def create
    @heading = 'Access Login'
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

  def destroy
    session[:admin] = false
    redirect_to root_url
  end

end
