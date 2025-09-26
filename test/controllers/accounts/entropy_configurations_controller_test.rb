require "test_helper"

class Account::EntropyConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "update" do
    put account_entropy_configuration_path, params: { entropy_configuration: { auto_postpone_period: 1.day } }

    assert_equal 1.day, entropy_configurations("37s_account").auto_postpone_period

    assert_redirected_to account_settings_path
  end
end
