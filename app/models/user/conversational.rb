module User::Conversational
  extend ActiveSupport::Concern

  included do
    has_one :conversation, dependent: :destroy
  end

  def start_or_continue_conversation(question = nil)
    create_conversation! unless conversation

    conversation.ask(question) if question.present?

    conversation
  end
end
