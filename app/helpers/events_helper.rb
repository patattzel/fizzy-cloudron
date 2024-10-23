module EventsHelper
  def boost_event_tag(event)
    tag.span hidden: true, data: { rollup_target: "boostEvent", creator_id: event.creator_id, creator_name: event.creator_name }
  end
end
