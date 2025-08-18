class Command::GoToCard < Command
  attr_reader :card

  def initialize(card)
    @card = card
  end

  def execute
    redirect_to card
  end
end
