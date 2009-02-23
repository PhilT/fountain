module PagesHelper
  def markup_help
    help = [ 'h1. heading',
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
    ]

    haml_tag :ul, :class => 'help' do
      help.each do |markup|
        haml_tag :li, markup, :class => cycle('odd', 'even')
      end
    end
  end

end
