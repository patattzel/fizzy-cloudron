require "test_helper"

class Signup::AccountsControllerTest < ActionDispatch::IntegrationTest
  test "new at a tenanted domain" do
    get new_signup_account_url

    assert_redirected_to root_url
  end

  test "new at an untenanted domain" do
    integration_session.host = "example.com" # no subdomain

    get new_signup_account_url

    assert_response :success
  end

  test "create with invalid params" do
    integration_session.host = "example.com" # no subdomain

    post signup_accounts_url, params: { signup: { full_name: "Jim", email_address: "jim@example.com", password: "", company_name: "" } }

    assert_response :unprocessable_entity
    assert_select "div.alert--error", text: /you need to choose a password/i
  end

  test "create for a new " do
    integration_session.host = "example.com" # no subdomain

    assert_difference -> { SignalId::Identity.count }, +1 do
      assert_difference -> { SignalId::Account.count }, +1 do
        post signup_accounts_url, params: { signup: { full_name: "Jim", email_address: "jim@example.com", password: SecureRandom.hex(12), company_name: "signup-accounts-controller-test-1" } }
      end
    end

    signal_account = SignalId::Account.last
    assert_redirected_to(/#{signal_account.login_url}/)
  end
end
