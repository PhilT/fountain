require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/layouts/application.html.haml" do
  include ApplicationHelper

  it "should render flash errors" do
    flash[:error] = "An error"
    render "/layouts/application.html.haml"
    response.should have_tag("div", "An error")
  end

  it "should not render div when no errors" do
    render "/layouts/application.html.haml"
    response.should_not have_tag("div.error", "")
  end
end
