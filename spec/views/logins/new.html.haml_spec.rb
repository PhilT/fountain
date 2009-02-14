require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/logins/new.html.haml" do
  include LoginsHelper

  it "should render new form" do
    render "/logins/new.html.haml"

    response.should have_tag("form[action=?][method=post]", logins_path) do
      with_tag("input#password")
    end
  end

  it "should render errors" do
    assigns[:error_message] = "Incorrect password"
    render "/logins/new.html.haml"
    response.should have_tag("p", "Incorrect password")
  end
end
