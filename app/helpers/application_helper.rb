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

  def edit_link
    if @page && !@page.new_record?
      haml_tag :li do
        haml_tag :span, link_to('edit', edit_page_path(@page)), {:id => 'edit'}
      end
    end
  end

  def login_link
    if current_user
      haml_tag :span, link_to('logout', user_session_path(current_user), {:method => :delete})
    else
      haml_tag :span, link_to('login', new_user_session_path)
    end
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

  def display_uploads_list
    if @page.uploads.count > 0
      for upload in @page.uploads
        haml_tag :li, link_to("#{upload.name} -- #{upload.document.url}", upload.document.url)
      end
    else
      haml_tag :span, 'No uploads.'
    end
  end
end

