require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.haml" do

  before do
    assigns[:heading] = 'title'
  end

  it "should render flash errors" do
    flash[:error] = "An error"
    render "/layouts/application.html.haml"
    response.should have_tag("div.error", "An error")
  end

  it "should not render div when no errors" do
    render "/layouts/application.html.haml"
    response.should_not have_tag("div.error", "")
  end

  it "should render h1 with a title" do
    render "/layouts/application.html.haml"
    response.should have_tag("h1", /title/)
  end

  it "should render history" do
    session[:history] = [mock_model(Page, :title => 'page 1'), mock_model(Page, :title => 'page 2')]
    render "/layouts/application.html.haml"
    response.should have_text(/li.*page 2.*li.*page 1/m)
  end
end
