module EventsHelper
  def event_day_title(day)
    case
    when day.today?
      "Today"
    when day.yesterday?
      "Yesterday"
    else
      day.strftime("%A, %B %e")
    end
  end

  def event_column(event)
    case event.action
    when "popped"
      4
    when "created"
      3
    when "commented"
      2
    else
      1
    end
  end

  def event_next_page_link(next_day)
    tag.div id: "next_page", data: { controller: "fetch-on-visible", fetch_on_visible_url_value: events_path(day: next_day) }
  end
end
