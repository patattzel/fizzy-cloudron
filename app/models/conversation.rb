class Conversation < ApplicationRecord
  include Broadcastable

  belongs_to :user, class_name: "User"
  has_many :messages, dependent: :destroy

  enum :state, %w[ ready thinking ].index_by(&:itself), default: :ready

  def cost
    messages.where.not(cost_microcents: nil).sum(:cost_microcents).to_d / 100_000
  end

  def clear
    messages.delete_all
    touch
  end

  def ask(question, **attributes)
    raise ArgumentError, "Question cannot be blank" if question.blank?

    message = nil
    with_lock do
      return if thinking?

      thinking!
      message = messages.create!(**attributes, role: :user, content: question)
    end

    message.broadcast_create
    broadcast_state_change

    message
  end

  def respond(answer, **attributes)
    raise ArgumentError, "Answer cannot be blank" if answer.blank?

    message = nil
    with_lock do
      return unless thinking?

      message = messages.create!(**attributes, role: :assistant, content: answer)
      ready!
    end

    message.broadcast_create
    broadcast_state_change

    message
  end
end
