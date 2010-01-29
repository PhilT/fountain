module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    path_mappings = {
      "the homepage" => lambda { self.root_path },
      "a Wiki Page" => lambda { self.page_path('wiki-page') },
      "edit the homepage" => lambda { edit_page_path(Page.find_by_name('HomePage')) },
      "the login page" => lambda { new_login_path }
    }
    mapping = path_mappings[page_name]
    if mapping
      mapping.call
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)

