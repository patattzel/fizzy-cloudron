require "test_helper"

class Taggings::SwapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "swap with same tag" do
    assert_changes "bubbles(:logo).tagged_with?(tags(:web))", from: true, to: false do
      post bucket_bubble_tagging_swaps_url(buckets(:writebook), bubbles(:logo)), params: {
        incoming_tag_id: tags(:web).id,
        outgoing_tag_id: tags(:web).id
      }
    end
    assert_redirected_to bubbles(:logo)
  end

  test "swap with another tag" do
    assert_changes "bubbles(:logo).tagged_with?(tags(:mobile))", from: false, to: true do
      assert_changes "bubbles(:logo).tagged_with?(tags(:web))", from: true, to: false do
        post bucket_bubble_tagging_swaps_url(buckets(:writebook), bubbles(:logo)), params: {
          incoming_tag_id: tags(:mobile).id,
          outgoing_tag_id: tags(:web).id
        }
      end
    end
    assert_redirected_to bubbles(:logo)
  end

  test "swap with another tag when already tagged" do
    assert_no_changes "bubbles(:layout).tagged_with?(tags(:mobile))" do
      assert_changes "bubbles(:layout).tagged_with?(tags(:web))", from: true, to: false do
        post bucket_bubble_tagging_swaps_url(buckets(:writebook), bubbles(:layout)), params: {
          incoming_tag_id: tags(:mobile).id,
          outgoing_tag_id: tags(:web).id
        }
      end
    end
    assert_redirected_to bubbles(:layout)
  end
end
