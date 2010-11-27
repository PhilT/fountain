require 'spec_helper'

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
      expected = [TextContent.new("<p><a class=\"new\" href=\"/pages/this-is-linked\">This Is Linked</a></p>\n\n"), PreformattedContent.new("<pre>\n<code>ThisIsNotLinked\n  </code>\n</pre>")]
      input_with_lf = "<p>ThisIsLinked</p>\n\n<pre>\n<code>ThisIsNotLinked\n  </code>\n</pre>"

      ContentFormatter.new(input_with_lf).split_pre_tags.should == expected
    end
  end

  describe Content do
    before do
      Factory(:page, :name => 'WikiWord', :title => 'Wiki Title')
    end

    describe 'hyperlink' do
      it 'should be created from existing WikiWord' do
        TextContent.new('existing WikiWord').content.should == "existing <a href=\"/pages/wiki-word\">Wiki Title</a>"
      end

      it 'should be created from SlightlyLongerWikiWords' do
        TextContent.new('SlightlyLongerWikiWords').content.should == "<a class=\"new\" href=\"/pages/slightly-longer-wiki-words\">Slightly Longer Wiki Words</a>"
      end

      it 'should be created from AndEvenTHIS' do
        TextContent.new('AndEvenTHIS').content.should == "<a class=\"new\" href=\"/pages/and-even-this\">And Even This</a>"
      end

      it 'should not be created for non-WikiWords' do
        TextContent.new('somePotentialNonWikiWords').content.should == "somePotentialNonWikiWords"
      end

      it "should not be created for wikiwords with a preceeding slash" do
        TextContent.new("\\ThisShouldNotGetLinked").content.should == 'ThisShouldNotGetLinked'
        TextContent.new("\\OneOfTheseShouldLink, OneOfTheseShouldLink").content.should == 'OneOfTheseShouldLink, <a class="new" href="/pages/one-of-these-should-link">One Of These Should Link</a>'
      end
    end
  end
end

