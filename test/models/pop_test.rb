require "test_helper"

class PopTest < ActiveSupport::TestCase
  test "default to the fallback reason if no reason is given" do
    assert_equal "Not now", Pop.new(reason: "Not now").reason
    assert_equal Account::PopReasons::FALLBACK_LABEL, Pop.new.reason
  end
end
