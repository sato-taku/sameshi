module ApplicationHelper
  def page_title(page_title = '')
    base_title = 'sameshi.'

    page_title.empty? ? base_title : page_title + ' | ' + base_title
  end

  def flash_background_color(type)
    case type.to_sym
    when :success then "bg-success"
    when :danger  then "bg-error"
    else "bg-info"
    end
  end
end
