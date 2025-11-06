module EventsHelper
  def event_columns(event_type, day_timeline)
    case event_type
    when "added"
      events = day_timeline.events.where(action: [ "card_published", "card_reopened" ])
      full_events_count = events.count
      {
        title: event_column_title("Added", full_events_count, day_timeline.day),
        index: 1,
        events: events.limit(100).load,
        full_events_count: full_events_count
      }
    when "closed"
      events = day_timeline.events.where(action: "card_closed")
      full_events_count = events.count
      {
        title: event_column_title("Closed", full_events_count, day_timeline.day),
        index: 3,
        events: events.limit(100).load,
        full_events_count: full_events_count
      }
    else
      events = day_timeline.events.where.not(action: [ "card_published", "card_closed", "card_reopened" ])
      full_events_count = events.count
      {
        title: event_column_title("Updated", full_events_count, day_timeline.day),
        index: 2,
        events: events.limit(100).load,
        full_events_count: full_events_count
      }
    end
  end

  private
    def event_column_title(base_title, count, day)
      date_tag = local_datetime_tag day, style: :agoorweekday
      parts = [ base_title, date_tag ]
      parts << tag.span("(#{count})", class: "font-weight-normal") if count > 0
      safe_join(parts, " ")
    end

    def event_column(event)
      case event.action
      when "card_closed"
        3
      when "card_published", "card_reopened"
        1
      else
        2
      end
    end

    def event_cluster_tag(hour, col, &)
      row = 25 - hour
      tag.div class: "events__time-block", style: "grid-area: #{row}/#{col}", &
    end

    def event_action_sentence_tag(event)
      creator = event_creator_name_tag(event)
      card = event.action.comment_created? ? event.eventable.card : event.eventable
      card_title = event_card_title(card)
      event_action_sentence(creator, card_title, event).html_safe
    end

    def event_action_sentence_text(event)
      creator = event_creator_name_text(event)
      card = event.action.comment_created? ? event.eventable.card : event.eventable
      card_title = card.title
      event_action_sentence(creator, card_title, event)
    end

    def event_creator_name_tag(event)
      tag.span data: { creator_id: event.creator.id } do
        safe_join([
          tag.span("You", data: { only_visible_to_you: true }),
          tag.span(h(event.creator.name), data: { only_visible_to_others: true })
        ])
      end
    end

    def event_creator_name_text(event)
      event.creator == Current.user ? "You" : h(event.creator.name)
    end

    def event_action_sentence(event_creator, event_card_title, event)
      if event.action.comment_created?
        comment_event_action_sentence(event_creator, event_card_title, event)
      else
        card_event_action_sentence(event_creator, event_card_title, event)
      end
    end

  def comment_event_action_sentence(event_creator, event_card_title, event)
    "#{event_creator} commented on #{event_card_title}"
  end

  def card_event_action_sentence(event_creator, event_card_title, event)
    case event.action
    when "card_assigned"
      if event.assignees.include?(Current.user)
        "#{event_creator} will handle #{event_card_title}"
      else
        "#{event_creator} assigned #{h event.assignees.pluck(:name).to_sentence} to #{event_card_title}"
      end
    when "card_unassigned"
      "#{event_creator} unassigned #{h(event.assignees.include?(Current.user) ? "yourself" : event.assignees.pluck(:name).to_sentence)} from #{event_card_title}"
    when "card_published"
      "#{event_creator} added #{event_card_title}"
    when "card_closed"
      "#{event_creator} moved #{event_card_title} to “Done”"
    when "card_reopened"
      "#{event_creator} reopened #{event_card_title}"
    when "card_postponed"
      "#{event_creator} moved #{event_card_title} to “Not Now”"
    when "card_auto_postponed"
      "#{event_card_title} was closed as “Not Now” due to inactivity"
    when "card_resumed"
      "#{event_creator} resumed #{event_card_title}"
    when "card_title_changed"
      "#{event_creator} renamed #{event_card_title} (was: “#{h event.particulars.dig('particulars', 'old_title')}”)"
    when "card_board_changed", "card_collection_changed"
      "#{event_creator} moved #{event_card_title} to “#{h (event.particulars.dig('particulars', 'new_board') || event.particulars.dig('particulars', 'new_collection'))}”"
    when "card_triaged"
      "#{event_creator} moved #{event_card_title} to “#{h event.particulars.dig('particulars', 'column')}”"
    when "card_sent_back_to_triage"
      "#{event_creator} moved #{event_card_title} back to “Maybe?”"
    end
  end

  def event_card_title(card)
    tag.span card.title, class: "txt-underline"
  end

  def event_due_date(event)
    event.particulars.dig("particulars", "due_date").to_date.strftime("%B %-d")
  end

  def event_action_icon(event)
    case event.action
    when "card_assigned"
      "assigned"
    when "card_unassigned"
      "minus"
    when "comment_created"
      "comment"
    when "card_title_changed"
      "rename"
    when "card_board_changed"
      "move"
    else
      "person"
    end
  end
end
