require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/edit.html.haml" do
  include PagesHelper

  before(:each) do
    assigns[:page] = @page = stub_model(Page,
      :name => "PageName",
      :title => "Page Title",
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/pages/edit.html.haml"
    response.should have_tag("form[action=#{page_path(@page)}][method=post]") do
      with_tag("input#page_name")
      with_tag("input#page_title")
      with_tag("textarea#page_content")
    end
  end

  it "should render edit form when a new record" do
    assigns[:page] = @page = stub_model(Page, :new_record? => true)
    render "/pages/edit.html.haml"
    response.should have_tag("form[action=#{pages_path}][method=post]") do
      with_tag("input#page_name")
    end
  end
end
