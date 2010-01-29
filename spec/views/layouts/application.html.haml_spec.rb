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
    page1 = mock_model(Page, :name => 'page 1', :title => 'Page 1')
    page2 = mock_model(Page, :name => 'page 2', :title => 'Page 2')
    Page.stub(:find_by_name).with(page1.name).and_return(page1)
    Page.stub(:find_by_name).with(page2.name).and_return(page2)
    session[:history] = [page1.name, page2.name]
    render "/layouts/application.html.haml"
    response.should have_text(/.*li.*Page 2.*li.*Page 1.*/m)
  end
end

