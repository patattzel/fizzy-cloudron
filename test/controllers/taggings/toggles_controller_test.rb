require "test_helper"

class Taggings::TogglesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create" do
    assert_changes "bubbles(:logo).tagged_with?(tags(:mobile))", from: false, to: true do
      post bucket_bubble_tagging_toggles_url(buckets(:writebook), bubbles(:logo)), params: { tag_id: tags(:mobile).id }
    end
    assert_redirected_to bubbles(:logo)

    assert_changes "bubbles(:logo).tagged_with?(tags(:web))", from: false, to: true do
      assert_changes "bubbles(:logo).tagged_with?(tags(:mobile))", from: true, to: false do
        post bucket_bubble_tagging_toggles_url(buckets(:writebook), bubbles(:logo)), params: { tag_id: tags(:web).id }
      end
    end
    assert_redirected_to bubbles(:logo)
  end
end
