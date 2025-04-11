require "test_helper"

class Card::GoldenTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "check whether a card is golden" do
    assert cards(:logo).golden?
    assert_not cards(:text).golden?
  end

  test "promote and demote from golden" do
    assert_changes -> { cards(:text).reload.golden? }, to: true do
      cards(:text).gild
    end

    assert_changes -> { cards(:logo).reload.golden? }, to: false do
      cards(:logo).ungild
    end
  end

  test "scopes" do
    assert_includes Card.golden, cards(:logo)
    assert_not_includes Card.golden, cards(:text)
  end
end
