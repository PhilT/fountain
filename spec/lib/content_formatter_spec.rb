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
      create_sections('<pre><code>preformatted</code></pre>', ' not preformatted')
      ContentFormatter.new(@content).split_pre_tags.should == @sections
    end

    it 'should handle pre and code tags with linefeeds' do
      expected = "<p><a class=\"new\" href=\"/pages/this-is-linked\">This Is Linked</a></p>\n\n<pre><code>Part of something\n</code></pre>"
      input_with_lf = "<p>ThisIsLinked</p>\n\n<pre><code>Part of something\n</code></pre>"

      ContentFormatter.new(input_with_lf).split_pre_tags.to_s.should == expected
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

    it "should not create hyperlinks for wikiwords with a slash and remove the slash" do
      content = TextContent.new("<p>LinkWithDifferentName is actually \\LinkWithDifferentName</p>").content
      content.should == "<p><a class=\"new\" href=\"/pages/link-with-different-name\">Link With Different Name</a> is actually LinkWithDifferentName</p>"
    end

  end
end

