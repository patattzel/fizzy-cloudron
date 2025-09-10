class Card::RemoveInaccessibleNotificationsJob < ApplicationJob
  def perform(card)
    card.remove_inaccessible_notifications
  end
end
