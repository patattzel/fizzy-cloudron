module User::DayTimeline::Summarizable
  extend ActiveSupport::Concern

  def summarized?
    summary.present?
  end

  def summary
    @summary ||= Event::ActivitySummary.for(events)
  end

  def summarize
    Event::ActivitySummary.create_for(events)
  end

  def summarize_later
    User::DayTimeline::SummarizeJob.perform_later(self)
  end
end
