require "test_helper"

class Bubble::PoppableTest < ActiveSupport::TestCase
  test "popped scope" do
    assert_equal [ bubbles(:shipping) ], Bubble.popped
    assert_not_includes Bubble.active, bubbles(:shipping)
  end

  test "popping" do
    assert_not bubbles(:logo).popped?

    with_current_user(:kevin) do
      bubbles(:logo).pop!
    end

    assert bubbles(:logo).popped?
  end
end
