def path_to(page_name)
  case page_name

  when /the homepage/i
    root_path

  # Add more page name => path mappings here
  when /the login page/i
    new_login_path

  when /a new page/i
    new_page_path

  else
    raise "Can't find mapping from \"#{page_name}\" to a path."
  end
end
