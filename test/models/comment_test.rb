require "test_helper"

class CommentTest < ActiveSupport::TestCase
  setup do
    Current.session = sessions(:david)
  end

  test "searchable by body" do
    message = bubbles(:logo).capture Comment.new(body: "I'd prefer something more rustic")

    assert_includes Comment.search("something rustic"), message.comment
  end

  test "updating bubble counter" do
    assert_changes "bubbles(:logo).activity_score" do
      assert_difference "bubbles(:logo).comments_count", 1 do
        bubbles(:logo).capture Comment.new(body: "I'd prefer something more rustic")
      end
    end

    assert_changes "bubbles(:logo).activity_score" do
      assert_difference "bubbles(:logo).comments_count", -1 do
        bubbles(:logo).messages.comments.last.destroy
      end
    end
  end
end
