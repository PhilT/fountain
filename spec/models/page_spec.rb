require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Page do
  describe "find_by_slug" do
    it "should convert a slug into a name and find by that" do
      page = Factory(:page, :name => "PageName")
      Page.find_by_slug("page-name").should == page
    end
  end

  describe "to_param" do
    it "should use convert page name to a slug" do
      Page.new(:name => "PageName").to_param.should == "page-name"
    end

    it "should handle invalid Rails model names" do
      Page.new(:name => "IsThisAValidPage").to_param.should == "is-this-a-valid-page"
      Page.new(:name => "UPPERCASE").to_param.should == "uppercase"
      Page.new(:name => "TLAWithOtherWords").to_param.should == "tla-with-other-words"
    end

  end

  describe "validations" do
    it "should not accept names with non-alphas" do
      page = Page.new(:name => 'NotValid?', :title => 'title')
      page.should_not be_valid
      page.errors.on('name').should match(/punctuation.*numbers/)
    end

    it "should have a title" do
      page = Page.new(:name => 'name')
      page.should_not be_valid
      page.errors.on('title').should == "can't be blank"
    end
  end
end
