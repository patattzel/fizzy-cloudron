require "test_helper"

class FilterChipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create" do
    post filter_chips_url(format: :turbo_stream), params: { text: "for David", name: "assignee_ids[]", value: users(:david).id, frame: "assignee_chips" }
    assert_response :success

    assert_turbo_stream action: :remove, target: "assignee_ids[]__filter--#{users(:david).id}"
    assert_turbo_stream action: :append, target: "assignee_chips"
    assert_select "button", text: "for David"
  end
end
