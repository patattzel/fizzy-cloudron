require "test_helper"

class Assignments::TogglesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "new" do
    get new_bucket_bubble_assignment_toggle_url(buckets(:writebook), bubbles(:logo))

    assert_response :success
  end

  test "create" do
    assert_changes "bubbles(:logo).assigned_to?(users(:david))", from: false, to: true do
      post bucket_bubble_assignment_toggles_url(buckets(:writebook), bubbles(:logo)), params: { assignee_id: users(:david).id }, as: :turbo_stream
    end
    assert_response :success

    assert_changes "bubbles(:logo).assigned_to?(users(:david))", from: true, to: false do
      post bucket_bubble_assignment_toggles_url(buckets(:writebook), bubbles(:logo)), params: { assignee_id: users(:kevin).id }, as: :turbo_stream
    end
    assert_response :success
  end
end
