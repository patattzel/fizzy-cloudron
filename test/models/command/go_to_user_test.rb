require "test_helper"

class Command::GoToUserTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  test "redirects to the user perma" do
    result = execute_command "@kevin"

    assert_equal users(:kevin), result.url
  end

  test "results in an invalid command if the user does not exist" do
    command = parse_command "@not_a_user"
    assert !command.valid?
  end
end
