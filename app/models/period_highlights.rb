class PeriodHighlights < ApplicationRecord
  class << self
    def create_for(collections, starts_at:, duration: 1.week)
      starts_at = normalize_anchor_date(starts_at)
      key = key_for(collections)
      events = Event.where(collection: collections).where(created_at: starts_at..starts_at + duration)

      create_or_find_by!(key:, starts_at:, duration:) do |record|
        summarizer = Event::Summarizer.new(events)
        record.content = summarizer.summarized_content
        record.cost_in_microcents = summarizer.cost.in_microcents
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

  def to_html
    renderer = Redcarpet::Render::HTML.new
    markdowner = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true,)
    markdowner.render(content).html_safe
  end
end
