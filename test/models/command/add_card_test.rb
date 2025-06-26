require "test_helper"

class Command::AddCardTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  setup do
    Current.session = sessions(:david)
    @card = cards(:text)
  end

  test "create a new untitled card" do
    result = assert_difference -> { users(:david).accessible_cards.count }, +1 do
      execute_command "/add_card", context_url: collection_card_url(@card.collection, @card)
    end

    new_card = users(:david).accessible_cards.last
    assert_equal "", new_card.title
    assert_equal @card.collection, new_card.collection
    assert_equal collection_card_path(new_card.collection, new_card, focus_on_title: true), result.url
  end

  test "create a new titled card" do
    result = assert_difference -> { users(:david).accessible_cards.count }, +1 do
      execute_command "/add_card Review report", context_url: collection_card_url(@card.collection, @card)
    end

    new_card = users(:david).accessible_cards.last
    assert_equal "Review report", new_card.title
    assert_equal @card.collection, new_card.collection
    assert_equal collection_card_path(new_card.collection, new_card, focus_on_title: true), result.url
  end

  test "undo card creation" do
    command = parse_command "/add_card", context_url: collection_cards_url(@card.collection)
    command.execute

    assert_difference -> { users(:david).accessible_cards.count }, -1 do
      command.undo
    end
  end
end
