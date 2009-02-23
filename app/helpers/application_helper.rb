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
    session[:admin]
  end

  def edit_link
    if admin? && @page && !@page.new_record?
      haml_tag :div, link_to(image_tag('edit.png'), edit_page_path(@page)) + 'edit', {:id => 'edit'}
    else
      haml_tag :div, image_tag('edit_disabled.png', :alt => 'Edit disabled') + 'edit', :class => 'disabled'
    end
  end

  def login_link
    if admin?
      haml_tag :div, image_tag('login_disabled.png', :alt => 'Login disabled') + 'login', :class => 'disabled'
      haml_tag :div, link_to(image_tag('logout.png'), login_path(1), {:method => :destroy}) + 'logout'
    else
      haml_tag :div, link_to(image_tag('login.png'), new_login_path) + 'login'
      haml_tag :div, image_tag('login_disabled.png', :alt => 'Login disabled') + 'logout', :class => 'disabled'
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
        haml_tag :li, link_to(page.title, page_path(page))
      end
    end
  end

end
