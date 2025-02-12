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
    tag.div class: "event__wrapper", style: "grid-area: #{row}/#{col}", &
  end

  def event_next_page_link(next_day)
    if next_day
      tag.div id: "next_page",
        data: { controller: "fetch-on-visible", fetch_on_visible_url_value: events_path(day: next_day.strftime("%Y-%m-%d")) }
    end
  end

  def render_event_grid_cells(day, columns: 4, rows: 24)
    safe_join((2..rows + 1).map do |row|
      (1..columns).map do |col|
        tag.div class: class_names("event__grid-item"), style: "grid-area: #{row}/#{col};"
      end
    end.flatten)
  end

  def render_column_headers(day = Date.current)
    start_time = day.beginning_of_day
    end_time = day.end_of_day

    headers = {
      "Touched" => nil,
      "Discussed" => nil,
      "Added" => Event.where(action: "published", created_at: start_time..end_time).count,
      "Popped" => Event.where(action: "popped", created_at: start_time..end_time).joins(:creator).merge(User.without_system).count
    }

    headers.map do |header, count|
      title = count&.positive? ? "#{header} (#{count})" : header
      content_tag(:h3, title, class: "event__grid-column-title margin-block-end-half position-sticky")
    end.join.html_safe
  end

  def event_action_sentence(event)
    case event.action
    when "assigned"
      "Assigned to <strong>#{ event.assignees.pluck(:name).to_sentence }</strong>".html_safe
    when "unassigned"
      "Unassigned <strong>#{ event.assignees.pluck(:name).to_sentence }</strong>".html_safe
    when "boosted"
      "Boosted by <strong>#{ event.creator.name }</strong>".html_safe
    when "commented"
      "#{ strip_tags(event.comment.body_html).blank? ? "<strong>#{ event.creator.name }</strong> replied.".html_safe : "<strong>#{ event.creator.name }:</strong>" } #{ strip_tags(event.comment.body_html).truncate(200) }".html_safe
    when "published"
      "Added by <strong>#{ event.creator.name }</strong>".html_safe
    when "popped"
      "Popped by <strong>#{ event.creator.name }</strong>".html_safe
    when "staged"
      "<strong>#{event.creator.name}</strong> moved to #{event.stage_name}.".html_safe
    when "due_date_added"
      "<strong>#{event.creator.name}</strong> set the date to #{event.particulars.dig('particulars', 'due_date').to_date.strftime('%B %-d')}".html_safe
    when "due_date_changed"
      "<strong>#{event.creator.name}</strong> changed the date to #{event.particulars.dig('particulars', 'due_date').to_date.strftime('%B %-d')}".html_safe
    when "due_date_removed"
      "#{event.creator.name} removed the date"
    when "title_changed"
      "<strong>#{event.creator.name}</strong> renamed this (was: '#{event.particulars.dig('particulars', 'old_title')})'".html_safe
    end
  end

  def event_action_icon(event)
    case event.action
    when "assigned"
      "arrow-right"
    when "boosted"
      "thumb-up"
    when "staged"
      "bolt"
    when "unassigned"
      "remove-med"
    when "due_date_added", "due_date_changed"
      "calendar"
    else
      "person"
    end
  end
end
