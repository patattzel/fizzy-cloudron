require "test_helper"

class User::RoleTest < ActiveSupport::TestCase
  test "can administer others?" do
    assert users(:kevin).can_administer?(users(:jz))

    assert_not users(:kevin).can_administer?(users(:kevin))
    assert_not users(:jz).can_administer?(users(:kevin))
  end
end
