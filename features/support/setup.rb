content = <<END
**some bold text** WikiWordsPointToOtherPages

    WikiWordsNotLinkedInCodeTags


A Heading
---------
END

Page.destroy_all
Page.create!(:name => 'WikiPage', :title => 'Wiki Page', :content => content)
Page.create!(:name => 'HomePage', :title => 'Home Page', :content => 'WikiPage NewPage')

