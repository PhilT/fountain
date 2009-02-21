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

  describe "from_slug" do
    it "should instaniate a new page with the name and title set from the slug" do
      page = Page.from_slug('page-name')
      page.name.should == 'PageName'
      page.title.should == 'Page Name'
    end
  end

  describe "validations" do
    it "should not accept names with non-alphas" do
      page = Page.new(:name => 'NotValid?', :title => 'title')
      page.should_not be_valid
      page.errors.on('name').should match(/punctuation.*numbers/)
    end

    it "should have a title" do
      page = Page.new(:name => 'page name')
      page.title.should == 'Page Name'
    end
  end

  describe "fomatted_content" do
    before do
      Factory(:page, :name => 'WikiWord', :title => 'Wiki Title')
    end

    it "should turn a WikiWord into a link using title and slug" do
      Page.new(:content => ' WikiWord').formatted_content.should == '<a href="/pages/wiki-word">Wiki Title</a>'
    end

    it "should turn a WikiWord into a link when surrounded by a tag" do
      Page.new(:content => 'WikiWord').formatted_content.should == '<p><a href="/pages/wiki-word">Wiki Title</a></p>'
    end

    it "should not link 'QuotedWikiWords'" do
      Page.new(:content => "'QuotedWikiWords'").formatted_content.should == "<p>&#8216;QuotedWikiWords&#8217;</p>"
    end

    it "should not link !BangedWikiWords" do
      Page.new(:content => ' a !WikiWord').formatted_content.should == 'a WikiWord'
    end

    it "should not link WikiWords inside pre tags" do
      Page.new(:content => 'bc. a WikiWord').formatted_content.should == '<pre><code>a WikiWord</code></pre>'
    end

    it "should not link WikiWords inside code tags" do
      Page.new(:content => '@a WikiWord@').formatted_content.should == '<p><code>a WikiWord</code></p>'
    end

    it "should link to a WikiPage that has not been created" do
      Page.new(:content => 'NonExistentWikiPage').formatted_content.should == '<p><a class="new" href="/pages/non-existent-wiki-page">Non Existent Wiki Page</a></p>'
    end

  end
end
