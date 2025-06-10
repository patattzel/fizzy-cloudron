require "test_helper"

class Collections::PublicationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
    @collection = collections(:writebook)
  end

  test "publish a collection" do
    assert_not @collection.published?

    assert_changes -> { @collection.reload.published? }, from: false, to: true do
      post collection_publication_path(@collection)
    end

    assert_redirected_to edit_collection_path(@collection)
  end

  test "unpublish a collection" do
    @collection.publish
    assert @collection.published?

    assert_changes -> { @collection.reload.published? }, from: true, to: false do
      delete collection_publication_path(@collection)
    end

    assert_redirected_to edit_collection_path(@collection)
  end
end
