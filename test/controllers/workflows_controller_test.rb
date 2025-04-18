require "test_helper"

class WorkflowsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "index" do
    get workflows_path
    assert_in_body workflows(:on_call).name
  end

  test "create" do
    assert_difference -> { Workflow.count }, +1 do
      post workflows_path, params: { workflow: { name: "My new workflow!" } }
      assert_redirected_to workflows_path
    end
  end
end
