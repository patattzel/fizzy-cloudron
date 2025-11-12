require "test_helper"

class Comment::SearchableTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    ActiveRecord::Base.connection.execute "DELETE FROM search_index"
    Account.find_by(name: "Search Test")&.destroy

    @account = Account.create!(name: "Search Test")
    @user = User.create!(name: "Test User", account: @account)
    @board = Board.create!(name: "Test Board", account: @account, creator: @user)
    @card = @board.cards.create!(title: "Test Card", creator: @user)
  end

  teardown do
    ActiveRecord::Base.connection.execute "DELETE FROM search_index"
    Account.find_by(name: "Search Test")&.destroy
  end

  test "comment search" do
    # Comment is indexed on create
    comment = @card.comments.create!(body: "searchable comment text", creator: @user)
    result = ActiveRecord::Base.connection.execute(
      "SELECT COUNT(*) FROM search_index WHERE searchable_type = 'Comment' AND searchable_id = #{comment.id}"
    ).first[0]
    assert_equal 1, result

    # Comment is updated in index
    comment.update!(body: "updated text")
    content = ActiveRecord::Base.connection.execute(
      "SELECT content FROM search_index WHERE searchable_type = 'Comment' AND searchable_id = #{comment.id}"
    ).first[0]
    assert_match /updat/, content

    # Comment is removed from index on destroy
    comment_id = comment.id
    comment.destroy
    result = ActiveRecord::Base.connection.execute(
      "SELECT COUNT(*) FROM search_index WHERE searchable_type = 'Comment' AND searchable_id = #{comment_id}"
    ).first[0]
    assert_equal 0, result

    # Finding cards via comment search
    card_with_comment = @board.cards.create!(title: "Card One", creator: @user)
    card_with_comment.comments.create!(body: "unique searchable phrase", creator: @user)
    card_without_comment = @board.cards.create!(title: "Card Two", creator: @user)
    results = Card.mentioning("searchable", board_ids: [@board.id])
    assert_includes results, card_with_comment
    assert_not_includes results, card_without_comment

    # Comment stores parent card_id and board_id
    new_comment = @card.comments.create!(body: "test comment", creator: @user)
    row = ActiveRecord::Base.connection.execute(
      "SELECT card_id, board_id FROM search_index WHERE searchable_type = 'Comment' AND searchable_id = #{new_comment.id}"
    ).first
    assert_equal @card.id, row[0]
    assert_equal @board.id, row[1]
  end
end
