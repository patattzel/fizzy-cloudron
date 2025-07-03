require "test_helper"

class Collections::EntropyConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
    @collection = collections(:writebook)
  end

  test "update" do
    put collection_entropy_configuration_path(@collection), params: { collection: { auto_close_period: 1.day, auto_reconsider_period: 2.days } }

    assert_equal 1.day, @collection.entropy_configuration.reload.auto_close_period
    assert_equal 2.days, @collection.entropy_configuration.reload.auto_reconsider_period

    assert_turbo_stream action: :replace, target: dom_id(@collection, :entropy_configuration)
  end
end
