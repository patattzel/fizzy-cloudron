require "test_helper"

class CommandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "command that results in a redirect" do
    assert_difference -> { users(:kevin).commands.count }, +1 do
      post commands_path, params: { command: "#{cards(:logo).id}" }
    end

    assert_redirected_to cards(:logo)
  end

  test "command that triggers a redirect back" do
    assert_difference -> { users(:kevin).commands.count }, +1 do
      post commands_path, params: { command: "/assign @kevin" }, headers: { "HTTP_REFERER" => cards_path }
    end

    assert_redirected_to cards_path
  end

  test "re-render form on error" do
    post commands_path, params: { command: "/assign @some_missing_user" }, headers: { "HTTP_REFERER" => cards_path }
    assert_turbo_stream action: :replace, target: "commands_form"
  end
end
