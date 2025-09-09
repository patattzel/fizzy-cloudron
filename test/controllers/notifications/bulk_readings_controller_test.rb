require "test_helper"

class Notifications::BulkReadingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "create" do
    assert_changes -> { notifications(:logo_published_kevin).reload.read? }, from: false, to: true do
      assert_changes -> { notifications(:layout_commented_kevin).reload.read? }, from: false, to: true do
        post bulk_reading_path
      end
    end
  end
end
