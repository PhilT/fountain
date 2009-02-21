require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/show.html.haml" do

  it "should render page using preformatted content from model" do
    page = mock(Page)
    page.should_receive(:formatted_content).and_return('content')

    assigns[:page] = page
    render "/pages/show.html.haml"
  end
end
