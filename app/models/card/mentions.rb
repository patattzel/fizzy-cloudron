module Card::Mentions
  extend ActiveSupport::Concern

  included do
    include ::Mentions
  end

  private
    def mentionable_content
      description.to_plain_text
    end
end
