require "test_helper"

class Assignments::SwapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "swap with same user" do
    assert_changes "bubbles(:logo).assigned_to?(users(:kevin))", from: true, to: false do
      post bucket_bubble_assignment_swaps_url(buckets(:writebook), bubbles(:logo)), params: {
        incoming_assignee_id: users(:kevin).id,
        outgoing_assignee_id: users(:kevin).id
      }
    end
    assert_redirected_to bubbles(:logo)
  end

  test "swap with another user" do
    assert_changes "bubbles(:logo).assigned_to?(users(:david))", from: false, to: true do
      assert_changes "bubbles(:logo).assigned_to?(users(:kevin))", from: true, to: false do
        post bucket_bubble_assignment_swaps_url(buckets(:writebook), bubbles(:logo)), params: {
          incoming_assignee_id: users(:david).id,
          outgoing_assignee_id: users(:kevin).id
        }
      end
    end
    assert_redirected_to bubbles(:logo)
  end

  test "swap with another user when already assigned" do
    assert_no_changes "bubbles(:logo).assigned_to?(users(:jz))" do
      assert_changes "bubbles(:logo).assigned_to?(users(:kevin))", from: true, to: false do
        post bucket_bubble_assignment_swaps_url(buckets(:writebook), bubbles(:logo)), params: {
          incoming_assignee_id: users(:jz).id,
          outgoing_assignee_id: users(:kevin).id
        }
      end
    end
    assert_redirected_to bubbles(:logo)
  end
end
