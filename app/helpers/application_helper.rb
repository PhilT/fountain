# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def display_flash
    for name in [:error, :warning, :notice]
      if flash[name]
        haml_tag :div, flash[name], {:class => name.to_s}
      end
    end
    nil
  end

  def history_list
    history = session[:history]
    return unless history
    haml_tag :ul do
      history.reverse.each do |page|
        page = Page.find_by_name(page)
        haml_tag :li, link_to(page.title, page_path(page)) if page
      end
    end
  end

  def username(version)
    User.find(version.whodunnit).name
  end

  def created_or_updated(version)
    %w(create update).include?(version.event) ? "#{version.event}d" : "#{version.event}ed"
  end
end

