module EntropyHelper
  def entropy_auto_close_options
    [ 3, 7, 11, 30, 90, 365 ]
  end

  def entropy_bubble_options_for(card)
    {
      daysBeforeReminder: Card::Entropic::ENTROPY_REMINDER_BEFORE.in_days.to_i,
      closesAt: card.entropy.auto_clean_at.iso8601,
      action: card_entropy_action(card)
    }
  end

  def card_entropy_action(card)
    if card.doing?
      "Falls Back"
    elsif card.considering?
      "Closes"
    end
  end
end
