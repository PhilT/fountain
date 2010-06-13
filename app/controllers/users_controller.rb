class UsersController < ApplicationController
  def new
    @heading = "Create New User"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  private
  def login_required
    super unless User.count == 0
  end
end

