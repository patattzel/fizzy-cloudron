require "test_helper"

class User::RoleTest < ActiveSupport::TestCase
  test "can administer others?" do
    assert users(:kevin).can_administer?(users(:jz))

    assert_not users(:kevin).can_administer?(users(:kevin))
    assert_not users(:jz).can_administer?(users(:kevin))
  end

  test "can administer board?" do
    writebook_board = boards(:writebook)
    private_board = boards(:private)

    # Admin can administer any board
    assert users(:kevin).can_administer_board?(writebook_board)
    assert users(:kevin).can_administer_board?(private_board)

    # Creator can administer their own board
    assert users(:david).can_administer_board?(writebook_board)

    # Regular user cannot administer boards they didn't create
    assert_not users(:jz).can_administer_board?(writebook_board)
    assert_not users(:jz).can_administer_board?(private_board)

    # Creator cannot administer other people's boards
    assert_not users(:david).can_administer_board?(private_board)
  end
end
