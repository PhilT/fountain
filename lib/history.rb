module History

private
  SIZE = 15

  def record(page)
    return if page.name == 'HomePage'
    history.reject!{ |p| p == page.name }
    history << page.name
    history.delete_at(0) if history.size > SIZE
  end

  def history
    session[:history] = [] unless session[:history]
    session[:history]
  end

end
