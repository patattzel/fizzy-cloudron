class Card::ActivitySpike::Detector
  attr_reader :card

  def initialize(card)
    @card = card
  end

  def detect
    if has_activity_spike?
      register_activity_spike
      true
    else
      false
    end
  end

  private
    def has_activity_spike?
      card.entropic? && (multiple_people_commented? || card_was_just_assigned? || card_was_just_reopened?)
    end

    def register_activity_spike
      if card.activity_spike
        card.activity_spike.touch
      else
        card.create_activity_spike!
      end
    end

    def multiple_people_commented?
      card.comments
        .where("created_at >= ?", recent_period.seconds.ago)
        .group(:card_id)
        .having("COUNT(*) >= ?", minimum_comments)
        .having("COUNT(DISTINCT creator_id) >= ?", minimum_participants)
        .exists?
    end

    def recent_period
      card.entropy.auto_clean_period * 0.33
    end

    def minimum_participants
      2
    end

    def minimum_comments
      3
    end

    def card_was_just_assigned?
      card.assigned? && last_recent_event_was?(:card_assigned)
    end

    def card_was_just_reopened?
      card.open? && last_recent_event_was?(:card_reopened)
    end

    def last_recent_event_was?(action)
      last_event&.action&.to_s == action.to_s && last_event.created_at > 1.minute.ago
    end

    def last_event
      card.events.last
    end
end
