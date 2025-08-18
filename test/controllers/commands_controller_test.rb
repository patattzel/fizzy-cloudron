require "test_helper"

class CommandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "command that results in a redirect" do
    post commands_path, params: { command: "#{cards(:logo).id}" }

    assert_redirected_to cards(:logo)
  end

  test "command that triggers a redirect back" do
    post commands_path, params: { command: "design" }

    assert_redirected_to search_path(q: "design")
  end
end
