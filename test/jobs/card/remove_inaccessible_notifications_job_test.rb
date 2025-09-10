require "test_helper"

class Card::RemoveInaccessibleNotificationsJobTest < ActiveJob::TestCase
  test "calls remove_inaccessible_notifications on the card" do
    card = cards(:logo)

    Card.any_instance.expects(:remove_inaccessible_notifications)

    Card::RemoveInaccessibleNotificationsJob.perform_now(card)
  end
end
