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

  def stalled_bubble_options_for(card)
    if card.last_activity_spike_at
      {
        stalledAfterDays: Card::Stallable::STALLED_AFTER_LAST_SPIKE_PERIOD.in_days.to_i,
        lastActivitySpikeAt: card.last_activity_spike_at.iso8601
      }
    end
  end

  def card_entropy_action(card)
    if card.doing?
      "Falls Back"
    elsif card.considering?
      "Closes"
    end
  end
end
