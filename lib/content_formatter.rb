class ContentFormatter

  def initialize(content)
    @content = content
  end

  def to_s
    split_pre_tags.map(&:content).join
  end

  def split_pre_tags
    @content.split(/(<pre>.*?<\/pre>|<code>.*?<\/code>)/).reject{|section| section.blank?}.map do |section|
      section.match(/^<pre>|^<code>/) ? PreformattedContent.new(section) : TextContent.new(section)
    end
  end
end

class Content
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def to_s
    self.content
  end

  def ==(other)
    self.content == other.content
  end
end

class PreformattedContent < Content
end

class TextContent < Content
  # A WikiWord is:
  # Preceeded by whitespace, parenthesis, or start of string      (?:\w|\(|^|>)
  # Uppercase letter(s)                                           [A-Z]+
  # Lowercase letter(s) or numbers(s)                             [a-z0-9]+
  # Uppercase letter(s)                                           [A-Z]+
  # Optional lowercase or uppercase letter(s) or number(s)        [a-zA-Z0-9]*
  wikiword_regex_suffix = '([A-Z]+[a-z0-9]+[A-Z]+[a-zA-Z0-9]*)'
  @@wikiword_regex = Regexp.new('(?:\s|\(|^|>)' + wikiword_regex_suffix)
  @@bangs_regex = Regexp.new('(!)' + wikiword_regex_suffix)

  def content
    @content.scan(@@wikiword_regex).flatten.each do |word|
      page = Page.find_or_initialize_by_name(word)
      klass = 'class="new" ' if page.new_record?
      @content.gsub!(word, "<a #{klass}href=\"/pages/#{page.to_param}\">#{page.title}</a>")
    end
    @content.gsub(@@bangs_regex, '\2')
  end
end
