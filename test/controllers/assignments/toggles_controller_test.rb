require "test_helper"

class Assignments::TogglesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create" do
    assert_changes "bubbles(:logo).assigned_to?(users(:david))", from: false, to: true do
      post bucket_bubble_assignment_toggles_url(buckets(:writebook), bubbles(:logo)), params: { assignee_id: users(:david).id }
    end
    assert_redirected_to bubbles(:logo)

    assert_changes "bubbles(:logo).assigned_to?(users(:david))", from: true, to: false do
      post bucket_bubble_assignment_toggles_url(buckets(:writebook), bubbles(:logo)), params: { assignee_id: users(:kevin).id }
    end
    assert_redirected_to bubbles(:logo)
  end
end
