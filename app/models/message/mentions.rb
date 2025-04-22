module Message::Mentions
  extend ActiveSupport::Concern

  included do
    include ::Mentions
  end

  private
    def mentionable_content
      messageable.try(:body_plain_text)
    end
end
