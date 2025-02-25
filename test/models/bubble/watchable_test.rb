require "test_helper"

class Bubble::WatchableTest < ActiveSupport::TestCase
  setup do
    Watch.destroy_all
    Subscription.destroy_all
  end

  test "watched_by?" do
    assert_not bubbles(:logo).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), true)
    assert bubbles(:logo).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), false)
    assert_not bubbles(:logo).watched_by?(users(:kevin))
  end

  test "watched_by? when subscribed to the bucket" do
    buckets(:writebook).subscribe(users(:kevin))

    assert bubbles(:text).watched_by?(users(:kevin))

    bubbles(:logo).set_watching(users(:kevin), false)
    assert_not bubbles(:logo).watched_by?(users(:kevin))
  end
end
