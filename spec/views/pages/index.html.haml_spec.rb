require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/index.html.haml" do
  include PagesHelper

  before(:each) do
    assigns[:pages] = [
      stub_model(Page, :name => "PageName"),
      stub_model(Page, :name => "AnotherPage")
    ]
  end

  it "should render list of pages" do
    render "/pages/index.html.haml"
  end
end
