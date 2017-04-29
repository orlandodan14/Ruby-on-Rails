module ApplicationHelper
  
  # Returns the full title on a per-page basis:
  def full_title(page_title = "")
    web_title = "Members Only App"
    if page_title.empty?
      web_title
    else
      page_title + " | " + web_title
    end
  end
end
