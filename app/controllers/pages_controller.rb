class PagesController < ApplicationController
  include History
  def index
    @pages = Page.find(:all)
    @heading = 'Search and Index'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pages }
    end
  end

  def show
    @page = Page.find_by_slug(params[:id])
    if @page
      @heading = @page.title
      record @page
    else
      redirect_to new_page_url(:id => params[:id])
    end
  end

  def new
    @page = Page.from_slug(params[:id])
    @heading = 'New Page'
    render :action => 'edit'
  end

  def edit
    @page = Page.find_by_slug(params[:id])
    @heading = "Editing #{@page.title}"
    redirect_to @page unless admin?
  end

  def create
    @page = Page.new(params[:page])
    @heading = 'New Page'
    if @page.save
      record @page
      flash[:notice] = "<strong>#{@page.title}</strong> was successfully created"
      redirect_to(@page)
    else
      render :action => "new"
    end
  end

  def update
    @page = Page.find_by_slug(params[:id])
    @heading = "Editing #{@page.title}"

    if @page.update_attributes(params[:page])
      flash[:notice] = "<strong>#{@page.title}</strong> was successfully updated"
      redirect_to(@page)
    else
      render :action => "edit"
    end
  end

  def destroy
    @page = Page.find_by_slug(params[:id])
    @page.destroy
    redirect_to(root_url)
  end
end
