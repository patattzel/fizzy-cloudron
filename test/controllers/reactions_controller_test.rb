require "test_helper"

class Comments::ReactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :jz
    @comment = comments(:logo_agreement_jz)
  end

  test "create" do
    assert_turbo_stream_broadcasts [ @comment, :comments ], count: 1 do
      assert_difference -> { @comment.reactions.count }, 1 do
        post bucket_bubble_comment_reactions_url(@comment.bubble.bucket, @comment.bubble, @comment, format: :turbo_stream), params: { reaction: { content: "Great work!" } }
        assert_redirected_to bucket_bubble_comment_reactions_url(@comment.bubble.bucket, @comment.bubble, @comment)
      end
    end
  end

  test "destroy" do
    assert_turbo_stream_broadcasts [ @comment, :comments ], count: 1 do
      assert_difference -> { @comment.reactions.count }, -1 do
        delete bucket_bubble_comment_reaction_url(@comment.bubble.bucket, @comment.bubble, @comment, reactions(:kevin), format: :turbo_stream)
        assert_response :success
      end
    end
  end
end
