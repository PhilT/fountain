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
end
