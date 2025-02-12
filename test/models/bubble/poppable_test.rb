require "test_helper"

class Bubble::PoppableTest < ActiveSupport::TestCase
  test "popped scope" do
    assert_equal [ bubbles(:shipping) ], Bubble.popped
    assert_not_includes Bubble.active, bubbles(:shipping)
  end

  test "popping" do
    assert_not bubbles(:logo).popped?

    bubbles(:logo).pop!(user: users(:kevin))

    assert bubbles(:logo).popped?
    assert_equal users(:kevin), bubbles(:logo).popped_by
  end
end
