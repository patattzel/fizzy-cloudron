require "test_helper"

class Bubble::EngageableTest < ActiveSupport::TestCase
  test "check the engagement status of a bubble" do
    assert bubbles(:logo).doing?
    assert_not bubbles(:text).doing?

    assert_not bubbles(:logo).considering?
    assert bubbles(:text).considering?
  end

  test "change the engagement" do
    assert_changes -> { bubbles(:text).reload.doing? }, to: true do
      bubbles(:text).engage
    end

    assert_changes -> { bubbles(:logo).reload.doing? }, to: false do
      bubbles(:logo).reconsider
    end
  end

  test "scopes" do
    assert_includes Bubble.doing, bubbles(:logo)
    assert_not_includes Bubble.doing, bubbles(:text)

    assert_includes Bubble.considering, bubbles(:text)
    assert_not_includes Bubble.considering, bubbles(:logo)
  end
end
