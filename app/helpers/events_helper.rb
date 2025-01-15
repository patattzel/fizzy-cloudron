module EventsHelper
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
end
