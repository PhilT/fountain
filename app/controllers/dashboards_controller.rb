class DashboardsController < ApplicationController
  def show
    @versions = Version.all(:conditions => ['created_at > ?', 1.month.ago], :order => 'created_at DESC')
    @heading = 'Your Dashboard'
  end
end
