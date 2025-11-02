require "test_helper"

class Account::SedeableTest < ActiveSupport::TestCase
  setup do
    @account = Account.sole
  end

  test "setup_basic_template changes collection count" do
    assert_changes -> { Collection.count } do
      @account.setup_basic_template
    end
  end

  test "setup_customer_template changes collections, cards, and comments count" do
    assert_changes -> { Collection.count } do
      assert_changes -> { Card.count } do
        assert_changes -> { Comment.count } do
          @account.setup_customer_template
        end
      end
    end
  end
end
