require "test_helper"

class Identity::TransferableTest < ActiveSupport::TestCase
  test "transfer_id" do
    identity = identities(:david)
    transfer_id = identity.transfer_id

    assert_not_nil transfer_id

    # Should be able to find the identity using the transfer_id
    found_identity = Identity.find_by_transfer_id(transfer_id)
    assert_equal identity, found_identity
  end

  test "find_by_transfer_id" do
    identity = identities(:kevin)
    transfer_id = identity.transfer_id

    found = Identity.find_by_transfer_id(transfer_id)
    assert_equal identity, found
  end

  test "find_by_transfer_id with invalid id" do
    found = Identity.find_by_transfer_id("invalid_id")
    assert_nil found
  end

  test "find_by_transfer_id with expired id" do
    identity = identities(:jz)

    # Generate a transfer_id with short expiry
    expired_id = identity.signed_id(purpose: :transfer, expires_in: -1.second)

    found = Identity.find_by_transfer_id(expired_id)
    assert_nil found
  end
end
