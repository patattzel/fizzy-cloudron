module User::Conversational
  extend ActiveSupport::Concern

  included do
    has_one :conversation, dependent: :destroy
  end

  def start_or_continue_conversation
    conversation || create_conversation!
  end
end
