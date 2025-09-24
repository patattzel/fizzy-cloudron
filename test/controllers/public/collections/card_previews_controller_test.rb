require "test_helper"

class Public::Collections::CardPreviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin

    collections(:writebook).publish
  end

end
