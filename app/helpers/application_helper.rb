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

  def admin?
    true
  end

  def edit_link
    if admin? && @page && !@page.new_record?
      haml_tag :li do
        haml_tag :span, link_to('edit', edit_page_path(@page)), {:id => 'edit'}
      end
    end
  end

  def login_link
    if admin?
      haml_tag :span, link_to('logout', '#', {:method => :delete})
    else
      haml_tag :span, link_to('login', '#')
    end
  end

  def last_updated
    haml_tag :div, :id => 'datestamp' do
      haml_tag :span, 'last updated: '
      haml_tag :strong, @page.updated_at.to_date.to_s(:rfc822)
    end if @page && !@page.updated_at.blank?
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

end

