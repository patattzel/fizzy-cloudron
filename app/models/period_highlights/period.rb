class PeriodHighlights::Period
  attr_reader :collections, :starts_at, :duration

  def initialize(collections, starts_at:, duration:)
    @collections = collections
    @starts_at = normalize_anchor_date(starts_at)
    @duration = duration
  end

  def events
    @events ||= Event.where(collection: collections).where(created_at: window)
  end

  def has_activity?
    events.any?
  end

  def key
    @keu ||= Digest::SHA256.hexdigest(events.ids.sort.join("-"))
  end

  def as_params
    {
      key: key,
      starts_at: starts_at,
      duration: duration
    }
  end

  private
    def window
      starts_at..starts_at + duration
    end

    def normalize_anchor_date(date)
      date.utc.beginning_of_day
    end
end
