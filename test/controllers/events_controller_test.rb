require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
  end

  test "index" do
    get events_url

    assert_select "div.event--wrapper[style='grid-area: 9/1']" do
      assert_select "strong", text: "Layout is broken"
    end
  end

  test "index with a specific timezone" do
    cookies[:timezone] = "America/New_York"

    get events_url

    assert_select "div.event--wrapper[style='grid-area: 14/1']" do
      assert_select "strong", text: "Layout is broken"
    end
  end
end
