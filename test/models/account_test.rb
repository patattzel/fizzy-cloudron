require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "slug" do
    account = Account.sole
    assert_equal "/#{ApplicationRecord.current_tenant}", account.slug
  end
end
