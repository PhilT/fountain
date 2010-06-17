class VersionsController < ApplicationController
  def index
    @page = Page.find_by_slug(params[:page_id])
    @heading = @page.title if @page
  end

  def show
    @page = Page.find_by_slug(params[:page_id])
    @heading = @page.title

    version = params[:id].to_i
    if version > @page.versions.size
      flash[:notice] = "Version requested (#{version}) does not exist! Showing latest..."
    elsif version < @page.versions.size
      @page = @page.versions[version].reify
      @heading += ' (as of v' + version.to_s + ')'
    else
      @heading += ' (current version)'
    end

    if @page
      render :template => 'pages/show'
    else
      flash[:notice] = "error"
    end
  end
end
