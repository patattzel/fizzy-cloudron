require "test_helper"

class BubbleTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "boosting" do
    assert_difference %w[ bubbles(:logo).boost_count Event.count ], +1 do
      bubbles(:logo).boost!
    end
  end

  test "assigning" do
    bubbles(:logo).assign users(:david)

    assert_equal users(:kevin, :jz, :david), bubbles(:logo).assignees
    assert_equal [ users(:david) ], Event.last.assignees
  end

  test "searchable by title" do
    bubble = buckets(:writebook).bubbles.create! title: "Insufficient haggis", creator: users(:kevin)

    assert_includes Bubble.search("haggis"), bubble
  end

  test "mentioning" do
    bubble = buckets(:writebook).bubbles.create! title: "Insufficient haggis", creator: users(:kevin)
    bubbles(:logo).capture Comment.new(body: "I hate haggis")
    bubbles(:text).capture Comment.new(body: "I love haggis")

    assert_equal [ bubble, bubbles(:logo), bubbles(:text) ].sort, Bubble.mentioning("haggis").sort
  end
end
