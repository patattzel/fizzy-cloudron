require 'test_helper'

class User::MentionableTest < ActiveSupport::TestCase
  test "mentionable handles" do
    assert_equal [ "dhh", "david", "davidh" ], User.new(name: "David Heinemeier-Hansson").mentionable_handles
  end
end
