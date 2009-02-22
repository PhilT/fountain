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
    assigns[:page] = @page = stub_model(Page, :name => 'NewPage', :new_record? => true)
    render "/pages/edit.html.haml"
    response.should have_tag("form[action=#{pages_path}][method=post]") do
      with_tag("input#page_name")
    end
  end

  it "should not show delete button when new record" do
    assigns[:page] = @page = stub_model(Page, :name => 'NewPage', :new_record? => true)
    render "/pages/edit.html.haml"
    response.should_not have_text(/input.*Delete/)
  end

  it "should show a readonly name field" do
    render "/pages/edit.html.haml"
    response.should have_text(/input.*readonly/)
  end

  it "should show help line" do
    render "/pages/edit.html.haml"
    response.should have_text(/h1. heading/)
  end
end
