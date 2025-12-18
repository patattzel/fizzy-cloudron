require "test_helper"

class Account::TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "rename tag" do
    tag = tags(:web)

    patch account_tag_path(tag), params: { tag: { title: "Backend" } }

    assert_redirected_to account_settings_path(anchor: "tags")
    assert_equal "backend", tag.reload.title
  end

  test "destroy tag" do
    tag = tags(:mobile)

    assert_difference -> { Tag.count }, -1 do
      delete account_tag_path(tag)
    end

    assert_redirected_to account_settings_path(anchor: "tags")
    assert_not Tag.exists?(tag.id)
  end

  test "requires admin" do
    logout_and_sign_in_as :david

    patch account_tag_path(tags(:web)), params: { tag: { title: "blocked" } }
    assert_response :forbidden
  end
end
