class UserSessionsController < ApplicationController
  def new
    @heading = "Login"
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    redirect_to new_user_session_url
  end

  private
  def login_required
    redirect_to new_user_path if User.count == 0
  end
end

