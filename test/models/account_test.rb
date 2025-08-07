require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "slug" do
    account = Account.sole
    assert_equal "/#{account.queenbee_id}", account.slug
  end
end
