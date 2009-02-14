require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do

  def mock_page(stubs={})
    @mock_page ||= mock_model(Page, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all pages as @pages" do
      Page.should_receive(:find).with(:all).and_return([mock_page])
      get :index
      assigns[:pages].should == [mock_page]
    end

    describe "with mime type of xml" do
  
      it "should render all pages as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Page.should_receive(:find).with(:all).and_return(pages = mock("Array of Pages"))
        pages.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested page as @page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      get :show, :id => "37"
      assigns[:page].should equal(mock_page)
    end
    
    describe "with mime type of xml" do

      it "should render the requested page as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new page as @page" do
      Page.should_receive(:new).and_return(mock_page)
      get :new
      assigns[:page].should equal(mock_page)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested page as @page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      get :edit, :id => "37"
      assigns[:page].should equal(mock_page)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created page as @page" do
        Page.should_receive(:new).with({'these' => 'params'}).and_return(mock_page(:save => true))
        post :create, :page => {:these => 'params'}
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the created page" do
        Page.stub!(:new).and_return(mock_page(:save => true))
        post :create, :page => {}
        response.should redirect_to(page_url(mock_page))
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

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested page" do
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the requested page as @page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should redirect to the page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(page_url(mock_page))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested page" do
        Page.should_receive(:find).with("37").and_return(mock_page)
        mock_page.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :page => {:these => 'params'}
      end

      it "should expose the page as @page" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        assigns(:page).should equal(mock_page)
      end

      it "should re-render the 'edit' template" do
        Page.stub!(:find).and_return(mock_page(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested page" do
      Page.should_receive(:find).with("37").and_return(mock_page)
      mock_page.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the pages list" do
      Page.stub!(:find).and_return(mock_page(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(pages_url)
    end

  end

end
