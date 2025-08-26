require "test_helper"

class Notification::BundleTest < ActiveSupport::TestCase
  setup do
    @user = users(:david)
  end

  test "new notifications are bundled" do
    notification = assert_difference -> { @user.notification_bundles.pending.count }, 1 do
      @user.notifications.create!(source: events(:logo_published), creator: @user)
    end

    bundle = @user.notification_bundles.pending.last
    assert_includes bundle.notifications, notification
  end

  test "notifications are bundled withing the aggregation period" do
    notification_1 = assert_difference -> { @user.notification_bundles.pending.count }, 1 do
      @user.notifications.create!(source: events(:logo_published), creator: @user)
    end
    travel_to 3.hours.from_now

    notification_2 = assert_no_difference -> { @user.notification_bundles.count } do
      @user.notifications.create!(source: events(:logo_published), creator: @user)
    end
    travel_to 3.hours.from_now

    notification_3 = assert_difference -> { @user.notification_bundles.pending.count }, 1 do
      @user.notifications.create!(source: events(:logo_published), creator: @user)
    end

    bundle_1, bundle_2 = @user.notification_bundles.last(2)

  end
end
