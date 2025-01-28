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
    when "published"
      3
    when "commented"
      2
    else
      1
    end
  end

  def event_cluster_tag(hour, col, &)
    row = 25 - hour
    tag.div class: "event--cluster", style: "grid-area: #{row}/#{col}", &
  end

  def event_next_page_link(next_day)
    if next_day
      tag.div id: "next_page",
        data: { controller: "fetch-on-visible", fetch_on_visible_url_value: events_path(day: next_day.strftime("%Y-%m-%d")) }
    end
  end

  def render_event_grid_cells(day, columns: 4, rows: 25)
    safe_join((2..rows + 1).map do |row|
      current_hour = row == 26 - Time.current.hour && day.today?
      (1..columns).map do |col|
        tag.div class: class_names("event-grid-item", "current-hour": current_hour), style: "grid-area: #{row}/#{col};"
      end
    end.flatten)
  end

  def render_time_labels(day)
    time = day.beginning_of_day + 12.hours
    content_tag(:div,
      content_tag(:time,
        "Noon",
        datetime: time.strftime("%H:%M")
      ),
      class: "event-grid-time",
      style: "grid-area: #{26 - 12}/2 / #{26 - 12}/4;"
    )
  end

  def render_column_headers
    [ "Touched", "Discussed", "Added", "Popped" ].map do |header|
      content_tag(:h3, header, class: "event-grid-column-title margin-block-end-half")
    end.join.html_safe
  end
end
