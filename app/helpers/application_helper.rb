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

  def page_title
    title =  "#{controller.action_name.titleize}ing #{@page.name}"
    @page ? title || 'New Page' : controller.action_name
  end

  def edit_link
    if admin? && @page
      haml_tag :div, link_to(image_tag('edit.png'), edit_page_path(@page)) + 'edit', {:id => 'edit'}
    else
      haml_tag :div, image_tag('edit_disabled.png') + 'edit', :class => 'disabled'
    end
  end

  def login_link
    if admin?
      haml_tag :div, image_tag('login_disabled.png') + 'login', :class => 'disabled'
      haml_tag :div, link_to(image_tag('logout.png'), login_path(1), {:method => :destroy}) + 'logout'
    else
      haml_tag :div, link_to(image_tag('login.png'), new_login_path) + 'login'
      haml_tag :div, image_tag('login_disabled.png') + 'logout', :class => 'disabled'
    end
  end
end
