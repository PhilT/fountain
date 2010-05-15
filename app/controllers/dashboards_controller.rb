class DashboardsController < ApplicationController
  def show
    @version_groups = Version.all(:conditions => ['created_at > ?', 1.month.ago], :order => 'created_at DESC').group_by{|version| [version.whodunnit, version.created_at.to_date, version.event]}
    @heading = 'Your Dashboard'
  end
end
