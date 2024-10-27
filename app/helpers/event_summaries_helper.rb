module EventSummariesHelper
  def event_description_for(event)
    case event.action
    when "created"
      "Added by #{event.creator.name} #{time_ago_in_words(event.created_at)} ago."
    when "assigned"
      "Assigned to #{event.assignees.pluck(:name).to_sentence} #{time_ago_in_words(event.created_at)} ago."
    when "staged"
      "#{event.creator.name} moved this to '#{event.stage_name}'."
    when "unstaged"
      "#{event.creator.name} removed this from '#{event.stage_name}'."
    end
  end

  def tallied_boosts_for(event_summary)
    if (tally = event_summary.events.tallied_boosts.presence)
      tally.map { |creator, count| "#{creator.name} +#{count}" }.to_sentence + "."
    end
  end
end
