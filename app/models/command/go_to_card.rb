class Command::GoToCard < Command
  store_accessor :data, :card_id

  def card=(card)
    self.card_id = card.id
  end

  def execute
    redirect_to card
  end

  def description
    "Search '#{query}"
  end

  def to_command
    query
  end

  private
    def card
      user.accessible_cards.find(card_id)
    end
end
