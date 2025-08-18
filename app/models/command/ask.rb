class Command::Ask < Command
  attr_reader :question

  def initialize(question)
    @question = question
  end

  def execute
    conversation = Conversation.create_or_find_by(user: Current.user)
    conversation.ask(question) if question.present?

    Command::Result::ShowModal.new(turbo_frame: "conversation", url: conversation_path)
  end
end
