class PeriodHighlights < ApplicationRecord
  class << self
    def create_or_find_for(collections, starts_at:, duration: 1.week)
      starts_at = normalize_anchor_date(starts_at)

      self.for(collections, starts_at:, duration:) || create_for(collections, starts_at:, duration:)
    end

    def create_for(collections, starts_at:, duration: 1.week)
      starts_at = normalize_anchor_date(starts_at)
      key = key_for(collections)
      events = Event.where(collection: collections).where(created_at: starts_at..starts_at + duration)

      if events.any?
        summarizer = Event::Summarizer.new(events)
        summarized_content = summarizer.summarized_content # outside of transaction as this can be slow
        create_or_find_by!(key:, starts_at:, duration:) do |record|
          record.content = summarized_content
          record.cost_in_microcents = summarizer.cost.in_microcents
        end
      end
    end

    def for(collections, starts_at:, duration: 1.week)
      starts_at = normalize_anchor_date(starts_at)
      key = key_for(collections)
      find_by(key:, starts_at:, duration:)
    end

    private
      def key_for(collections)
        Digest::SHA256.hexdigest(collections.ids.sort.join("-"))
      end

      def normalize_anchor_date(date)
        date.utc.beginning_of_day
      end
  end

  def ends_at
    starts_at + duration
  end

  def to_html
    renderer = Redcarpet::Render::HTML.new
    markdowner = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true,)
    markdowner.render(content).html_safe
  end
end
