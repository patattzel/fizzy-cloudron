require "test_helper"

class SearchTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    ActiveRecord::Base.connection.execute "DELETE FROM search_index"
    Account.find_by(name: "Search Test")&.destroy

    @account = Account.create!(name: "Search Test")
    @user = User.create!(name: "Test User", account: @account)
    @board = Board.create!(name: "Test Board", account: @account, creator: @user)
  end

  teardown do
    ActiveRecord::Base.connection.execute "DELETE FROM search_index"
    Account.find_by(name: "Search Test")&.destroy
  end

  test "search" do
    # Search cards and comments
    card = @board.cards.create!(title: "layout design", creator: @user)
    comment_card = @board.cards.create!(title: "Some card", creator: @user)
    comment_card.comments.create!(body: "overflowing text", creator: @user)

    results = Search.new(@user, "layout").results
    assert results.find { |it| it.card_id == card.id }

    results = Search.new(@user, "overflowing").results
    assert results.find { |it| it.card_id == comment_card.id && it.comment_id.present? }

    # Don't include inaccessible boards
    other_user = User.create!(name: "Other User", account: @account)
    inaccessible_board = Board.create!(name: "Inaccessible Board", account: @account, creator: other_user)
    accessible_card = @board.cards.create!(title: "searchable content", creator: @user)
    inaccessible_card = inaccessible_board.cards.create!(title: "searchable content", creator: other_user)

    results = Search.new(@user, "searchable").results
    assert results.find { |it| it.card_id == accessible_card.id }
    assert_not results.find { |it| it.card_id == inaccessible_card.id }

    # Empty board_ids returns no results
    user_without_access = User.create!(name: "No Access User", account: @account)
    results = Search.new(user_without_access, "anything").results
    assert_empty results
  end
end
