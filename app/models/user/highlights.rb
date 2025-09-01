module User::Highlights
  extend ActiveSupport::Concern

  class_methods do
    def generate_all_weekly_highlights_later
      User::Highlights::GenerateAllJob.perform_later
    end

    def generate_all_weekly_highlights
      # We're not interested in parallelizing individual generation. Better for AI quota limits and, also,
      # most summaries will be reused for users accessing the same collections.
      find_each(&:generate_weekly_highlights)
    end
  end

  def generate_weekly_highlights
    PeriodHighlights.create_for collections, starts_at: current_highlights_starts_at, duration: 1.week
  end

  def current_weekly_highlights
    PeriodHighlights.for collections, starts_at: current_highlights_starts_at, duration: 1.week
  end

  private
    def current_highlights_starts_at
      Time.current.utc.beginning_of_week(:sunday)
    end
end
