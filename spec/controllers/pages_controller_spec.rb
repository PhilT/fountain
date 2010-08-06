require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  before(:each) do
    activate_authlogic
    UserSession.create(Factory :user)
  end

  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs.merge(:title => "Stubbed Page"))
  end

  describe "responding to GET index" do
    it "should expose all pages as @pages" do
      Factory(:page)

      get :index
      response.should be_success
      assigns(:pages).should_not be_empty
    end
  end

  describe "with mime type of xml" do
    it "should render all pages as xml" do
      request.env["HTTP_ACCEPT"] = "application/xml"
      Factory(:page)

      get :index
      response.should be_success
    end
  end

  describe "show" do
    it "should expose the requested page as @page" do
      Page.should_receive(:find_by_slug).with("page-slug").and_return(mock_page)
      controller.stub!(:record)
      get :show, :id => "page-slug"
      assigns[:page].should equal(mock_page)
    end

    it "should redirect to new page if @page does not exist" do
      Page.should_receive(:find_by_slug).with("page-slug").and_return(nil)
      get :show, :id => "page-slug"
      response.should redirect_to(new_page_url(:id => 'page-slug'))
    end

    it "should save page in history" do
      Page.stub!(:find_by_slug).with("page-slug").and_return(mock_page)
      controller.should_receive(:record).with(mock_page)
      get :show, :id => "page-slug"
    end

    it "should not save page in history if non-existent" do
      Page.should_receive(:find_by_slug).with("page-slug").and_return(nil)
      controller.should_not_receive(:record)
      get :show, :id => "page-slug"
    end
  end

  describe "new" do
    it "should set name and title if id is passed in" do
      Page.should_receive(:from_slug).with('page-slug').and_return(mock_page)
      get :new, :id => 'page-slug'
    end
  end

  describe "edit" do
    it "should expose the requested page as @page" do
      session[:admin] = true
      Page.should_receive(:find_by_slug).with("page-slug").and_return(mock_page)
      mock_page.stub_chain(:uploads, :build)
      get :edit, :id => "page-slug"
      assigns[:page].should equal(mock_page)
      response.should render_template('edit')
    end
  end

  describe "create" do
    describe "with valid params" do
      it "should expose a newly created page as @page" do
        Page.should_receive(:new).with({'name' => 'name'}).and_return(mock_page(:name => 'name', :save => true))
        post :create, :page => {:name => 'name'}
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the created page" do
        Page.stub!(:new).and_return(mock_page(:name => 'name', :save => true))
        post :create, :page => {}
        response.should redirect_to(page_url(mock_page))
      end

      it "should save page in history" do
        Page.should_receive(:new).with({'these' => 'params'}).and_return(mock_page(:name => 'name', :save => true))
        controller.should_receive(:record).with(mock_page)
        post :create, :page => {:these => 'params'}
      end
    end

    describe "with invalid params" do
      it "should expose a newly created but unsaved page as @page" do
        Page.stub!(:new).with({'these' => 'params'}).and_return(mock_page(:save => false))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "should re-render the 'new' template" do
        Page.stub!(:new).and_return(mock_page(:save => false))
        post :create, :page => {}
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT update" do
    describe "with valid params" do
      it "should update the requested page" do
        Page.should_receive(:find_by_slug).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the requested page as @page" do
        Page.stub!(:find_by_slug).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the page" do
        Page.stub!(:find_by_slug).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(page_url(mock_page))
      end

    end

    describe "with invalid params" do

      it "should update the requested page" do
        Page.should_receive(:find_by_slug).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the page as @page" do
        Page.stub!(:find_by_slug).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should re-render the 'edit' template" do
        Page.stub!(:find_by_slug).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested page" do
      Page.should_receive(:find_by_slug).with("page").and_return(mock_page)
      mock_page.should_receive(:destroy)
      delete :destroy, :id => "page"
    end

    it "should redirect to home page (or previous page?)" do
      Page.stub!(:find_by_slug).and_return(mock_page(:destroy => true))
      delete :destroy, :id => "page"
      response.should redirect_to(root_url)
    end

  end

end

