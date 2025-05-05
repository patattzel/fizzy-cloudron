class Command::Parser
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def parse(string)
    if card = user.accessible_cards.find_by_id(string)
      Command::GoToCard.new(card: card)
    else
      Command::Search.new(query: string)
    end
  end
end
