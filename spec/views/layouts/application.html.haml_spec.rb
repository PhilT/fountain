require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.haml" do

  before do
    template.stub!(:page_title).and_return('Page Title')
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
    response.should have_tag("h1", "Page Title")
  end
end
