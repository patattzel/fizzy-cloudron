require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "index" do
    get notifications_url

    assert_response :success
    assert_select "div", text: /Layout is broken/
  end
end
