require "test_helper"

class Bubbles::RecoversControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :jz
  end

  test "create" do
    abandoned_bubble = buckets(:writebook).bubbles.create! creator: users(:kevin)
    abandoned_bubble.update!(title: "An edited title")
    unsaved_bubble = buckets(:writebook).bubbles.create! creator: users(:kevin)

    post bubble_recover_url(unsaved_bubble)

    assert_redirected_to abandoned_bubble
    assert_equal [ abandoned_bubble ], Bubble.creating
  end
end
