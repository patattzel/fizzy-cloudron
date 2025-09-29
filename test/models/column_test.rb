require "test_helper"

class ColumnTest < ActiveSupport::TestCase
  test "creates column with default color when color not provided" do
    column = collections(:writebook).columns.create!(name: "New Column")

    assert_equal Card::DEFAULT_COLOR, column.color
  end
end
