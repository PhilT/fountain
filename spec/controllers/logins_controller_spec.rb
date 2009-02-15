require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LoginsController do

  describe "responding to POST create" do

    describe "with valid params" do

      before do
        Login.stub!(:valid?).and_return(true)
      end

      it "should validate the password" do
        Login.should_receive(:valid?).with("password")
        post :create, :password => "password"
      end

      it "should save admin flag in session" do
        post :create
        response.session[:admin].should be_true
      end

      it "should redirect to the Home page" do
        post :create
        response.should redirect_to(root_url)
      end

    end

    describe "with invalid params" do

      before do
        Login.stub!(:valid?).and_return(false)
      end

      it "should not set session" do
        post :create
        response.session[:admin].should_not be_true
      end

      it "should set error message" do
        post :create
        flash[:error].should == "Invalid Password"
      end

      it "should re-render the 'new' template" do
        post :create
        response.should render_template('new')
      end

    end

  end

end
