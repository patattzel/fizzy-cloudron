require "test_helper"

class Card::ScorableTest < ActiveSupport::TestCase
  test "recent activity counts more than older activity in the ordering" do
    with_current_user :kevin do
      travel_to 5.days.ago
      card_old = collections(:writebook).cards.create! status: :published, title: "old"
      card_mid = collections(:writebook).cards.create! status: :published, title: "mid"
      card_new = collections(:writebook).cards.create! status: :published, title: "new"

      card_old.boost!
      card_old.boost!

      travel_back
      travel_to 2.days.ago
      card_mid.boost!

      travel_back
      card_new.boost!

      assert_equal %w[ new mid old ], Card.where(id: [ card_old, card_mid, card_new ]).ordered_by_activity.map(&:title)
    end
  end

  test "items with old activity are more stale than those with none, or with new activity" do
    with_current_user :kevin do
      travel_to 20.days.ago
      card_old = collections(:writebook).cards.create! status: :published, title: "old"
      card_new = collections(:writebook).cards.create! status: :published, title: "new"
      card_none = collections(:writebook).cards.create! status: :published, title: "none"

      card_old.boost!
      card_old.boost!

      travel_back
      travel_to 2.days.ago
      card_new.boost!
      card_new.boost!

      travel_back

      assert_equal %w[ old new none ], Card.where(id: [ card_none, card_old, card_new ]).ordered_by_staleness.map(&:title)

      card_old.boost!

      assert_equal %w[ new old none ], Card.where(id: [ card_none, card_old, card_new ]).ordered_by_staleness.map(&:title)
    end
  end

  test "cards with no activity have a valid activity_score_order" do
    card = Card.create! collection: collections(:writebook), creator: users(:kevin)

    card.rescore

    assert card.activity_score.zero?
    assert_not card.activity_score_order.infinite?
  end
end
