class ContentFormatter

  def initialize(content)
    @content = content
  end

  def to_s
    split_pre_tags.map(&:content).join
  end

  def split_pre_tags
    @content.split(/(<pre>.*?<\/pre>|<code>.*?<\/code>)/m).reject{|section| section.blank?}.map do |section|
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
  no_backslash = '[^\\\\]'      # Not preceeded by a backslash
  preceeding = '(?:\s|\(|^|>)'  # Preceeded by whitespace, parenthesis, or start of string
  lowercase = '[a-z0-9]+'       # Lowercase letter(s) or numbers(s)
  uppercase = '[A-Z]+'          # Uppercase letter(s)
  optional = '[a-zA-Z0-9]*'     # Optional lowercase or uppercase letter(s) or number(s)
  wikiword_regex_suffix = '(' + uppercase + lowercase + uppercase + optional + ')'
  @@wikiword_regex = Regexp.new(preceeding + wikiword_regex_suffix)
  @@escape_regex = Regexp.new('(\\\\)' + wikiword_regex_suffix)

  def content
    @content.scan(@@wikiword_regex).flatten.each do |word|
      page = Page.find_or_initialize_by_name(word)
      klass = 'class="new" ' if page.new_record?
      @content.gsub!(word, "<a #{klass}href=\"/pages/#{page.to_param}\">#{page.title}</a>")
    end
    @content.gsub(@@escape_regex, '\2')
  end
end

