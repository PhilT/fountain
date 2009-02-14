require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/pages/edit.html.haml" do
  include PagesHelper

  before(:each) do
    assigns[:page] = @page = stub_model(Page,
      :new_record? => false
    )
  end

  it "should render edit form" do
    render "/pages/edit.html.haml"

    response.should have_tag("form[action=#{page_path(@page)}][method=post]") do
    end
  end
end
