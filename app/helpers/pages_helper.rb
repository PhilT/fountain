module PagesHelper
  include ActionView::Helpers::TagHelper

  def history
    session[:history].map do |page|
      link_to(page, page_path(page))
    end.join(' ')
  end

  def markup_help
    [ 'h1. header',
      'bc. block code',
      '_italic_',
      '*bold*',
      '@code@',
      '* bulleted item',
      '# numbered item',
      'WikiLink',
      '|column 1|column 2|',
      'bq. block quote',
      'fn1. reference',
      '+underline+',
      '-strikethrough-'
    ].map do |markup|
      content_tag('li', markup, :class => 'help')
    end.join
  end
end
