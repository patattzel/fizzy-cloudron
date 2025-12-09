require "test_helper"

class Boards::ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "show" do
    get board_column_path(boards(:writebook), columns(:writebook_in_progress))
    assert_response :success
  end

  test "create" do
    assert_difference -> { boards(:writebook).columns.count }, +1 do
      post board_columns_path(boards(:writebook)), params: { column: { name: "New Column" } }, as: :turbo_stream
      assert_response :success
    end

    assert_equal "New Column", boards(:writebook).columns.last.name
  end

  test "create refreshes sibling columns" do
    board = boards(:writebook)
    existing_columns = board.columns.to_a

    post board_columns_path(board), params: { column: { name: "New Column" } }, as: :turbo_stream

    existing_columns.each do |column|
      assert_turbo_stream action: :replace, target: dom_id(column)
    end
  end

  test "update" do
    column = columns(:writebook_in_progress)

    assert_changes -> { column.reload.name }, from: "In progress", to: "Updated Name" do
      put board_column_path(boards(:writebook), column), params: { column: { name: "Updated Name" } }, as: :turbo_stream
      assert_response :success
    end
  end

  test "destroy" do
    column = columns(:writebook_on_hold)

    assert_difference -> { boards(:writebook).columns.count }, -1 do
      delete board_column_path(boards(:writebook), column), as: :turbo_stream
      assert_response :success
    end
  end

  test "destroy refreshes sibling columns" do
    board = boards(:writebook)
    column = columns(:writebook_on_hold)
    sibling_columns = column.sibling_columns.to_a

    delete board_column_path(board, column), as: :turbo_stream

    sibling_columns.each do |sibling_column|
      assert_turbo_stream action: :replace, target: dom_id(sibling_column)
    end
  end
end
