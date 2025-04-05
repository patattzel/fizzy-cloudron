require "test_helper"

class Bubbles::PinsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create" do
    assert_changes -> { bubbles(:layout).pinned_by?(users(:kevin)) }, from: false, to: true do
      perform_enqueued_jobs do
        assert_turbo_stream_broadcasts([ users(:kevin), :pins ], count: 1) do
          post bucket_bubble_pin_path(buckets(:writebook), bubbles(:layout))
        end
      end
    end

    assert_redirected_to bucket_bubble_pin_path(buckets(:writebook), bubbles(:layout))
  end

  test "destroy" do
    assert_changes -> { bubbles(:shipping).pinned_by?(users(:kevin)) }, from: true, to: false do
      perform_enqueued_jobs do
        assert_turbo_stream_broadcasts([ users(:kevin), :pins ], count: 1) do
          delete bucket_bubble_pin_path(buckets(:writebook), bubbles(:shipping))
        end
      end
    end

    assert_redirected_to bucket_bubble_pin_path(buckets(:writebook), bubbles(:shipping))
  end
end
