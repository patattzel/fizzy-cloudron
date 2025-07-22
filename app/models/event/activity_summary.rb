class Event::ActivitySummary < ApplicationRecord
  validates :key, :contents, presence: true

  store_accessor :data, :event_ids

  class << self
    def create_for(events)
      summary = Event::Summarizer.new(events).summarize
      key = key_for(events)

      unless find_by key: key
        create!(key: key, contents: summary)
      end
    end

    def for(events)
      find_by key: key_for(events)
    end

    private
      def key_for(events)
        Digest::SHA256.hexdigest(events.ids.sort.join("-"))
      end
  end

  def to_html
    renderer = Redcarpet::Render::HTML.new
    markdowner = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true, strikethrough: true, superscript: true,)
    markdowner.render(contents).html_safe
  end
end
