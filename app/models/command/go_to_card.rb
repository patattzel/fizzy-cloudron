class Command::GoToCard < Command
  store_accessor :data, :card_id

  def execute
    redirect_to card
  end

  def title
    "Visit card '#{card.title}'"
  end

  private
    def card
      user.accessible_cards.find(card_id)
    end
end
