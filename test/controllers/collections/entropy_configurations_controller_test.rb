require "test_helper"

class Collections::EntropyConfigurationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as :kevin
    @collection = collections(:writebook)
  end

  test "update" do
    put collection_entropy_configuration_path(@collection), params: { collection: { auto_postpone_period: 1.day } }

    assert_equal 1.day, @collection.entropy_configuration.reload.auto_postpone_period

    assert_turbo_stream action: :replace, target: dom_id(@collection, :entropy_configuration)
  end
end
