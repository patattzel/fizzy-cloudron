class Command < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :parent, class_name: "Command", optional: true

  scope :root, -> { where(parent_id: nil) }

  attribute :context

  def title
    model_name.human
  end

  def confirmation_prompt
    title
  end

  def execute
  end

  def undo
  end

  def undo!
    transaction do
      undo
      destroy
    end
  end

  def undoable?
    false
  end

  def needs_confirmation?
    false
  end

  def error_messages
    errors.to_hash.flat_map do |attribute, message|
      error_message_for(attribute, message)
    end.uniq
  end

  private
    def redirect_to(...)
      Command::Result::Redirection.new(...)
    end

    def error_message_for(attribute, message)
      case attribute.to_sym
      when :cards, :card_ids
        ""
      when :card
        "Needs one or more cards to apply to (#123, #124)."
      when :collection
        "You need to specificy a Collection"
      when :assignee_ids
        "Needs at leaset one assignee (@person)."
      when :user
        "Can’t find that person."
      when :stage
        "Can’t find that Workflow Stage."
      when :tag_title
        "Needs at least one tag (#tag, #name)"
      else
        message
      end
    end
end
