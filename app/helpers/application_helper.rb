module ApplicationHelper
  def comment_panel_styling(c)
    if (Time.zone.now - c.created_at) <= 5.0
      'success'
    else
      'default'
    end
  end
end
