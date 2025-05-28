class Command::GoToCard < Command
  store_accessor :data, :card_id

  validates_presence_of :card

  def title
    "Visit card '#{card&.title}'"
  end

  def execute
    redirect_to card
  end

  private
    def card
      user.accessible_cards.find_by_id(card_id)
    end
end
