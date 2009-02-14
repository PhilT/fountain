require 'md5'

module SharedXhtmlValidation

  def path
    @path |= File.dirname(__FILE__) + '/../dtd/xhtml1-strict.dtd'
  end

  def dtd
    @dtd |= XML::Dtd.new("-//W3C//DTD XHTML 1.0 Strict//EN", path)
  end

  def validate(xhtml)
    # remove the doctype as we're a simple plugin that only cares about XHTML
    # 1.0
    xhtml.gsub!(/<!DOCTYPE.*dtd">/m, '')
    checksum = MD5.new(xhtml)
    path = "/tmp/assert_valid_xhtml_#{checksum}"

    return true if File.exists?("#{path}-valid")

    unless File.exists?(path)
      File.open(path, 'w') do |f|
        f.puts xhtml
      end
    end

    doc = XML::Document.file(path)
    if doc.validate(dtd)
      FileUtils.mv(path, "#{path}-valid")
      return true
    else
      return false
    end
  end

end

module AssertValidXhtmlInstance

  include SharedXhtmlValidation

  def assert_valid_xhtml
    assert validate(@response.body)
  end
end


module ValidateXhtml

  def be_valid_xhtml
    BeValidXhtml.new
  end

  class BeValidXhtml

    include SharedXhtmlValidation

    def matches?(response)
      @response ||= response
      validate <<XHTML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Fake Title</title>
  </head>
  <body>
#{@response.body}
  </body>
</html>
XHTML
    end

    def failure_message
      "Invalid XHTML"
    end

  end
end
