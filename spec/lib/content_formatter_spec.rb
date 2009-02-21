require 'spec/spec_helper'

describe ContentFormatter do
  def create_sections(pre, normal)
    @sections = [
      PreformattedContent.new(pre),
      TextContent.new(normal)
    ]
    @content = @sections.map(&:content).join
  end

  describe "split_pre_tags" do
    it "should split sections into pre and normal text" do
      create_sections('<pre>preformatted</pre>', ' not preformatted')
      ContentFormatter.new(@content).split_pre_tags.should == @sections
    end
  end

  describe Content do
    before do
      Factory(:page, :name => 'WikiWord', :title => 'Wiki Title')
    end

    it "should create hyperlinks for wikiwords" do
      content = TextContent.new('content with a WikiWord').content
      content.should == 'content with a <a href="/pages/wiki-word">Wiki Title</a>'
    end

    it "should not create hyperlinks for wikiwords with a bang and remove the bang" do
      content = TextContent.new('content with a !WikiWord').content
      content.should == 'content with a WikiWord'
    end

  end
end
