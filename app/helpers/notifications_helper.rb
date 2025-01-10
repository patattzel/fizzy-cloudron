module NotificationsHelper
  def notification_tray
    notification_stream_tag + notification_tray_tag
  end

  def notification_tag(notification, &)
    link_to notification.resource, class: "notification",
      data: {
        turbo_frame: "_top",
        action: "notifications--readings#record",
        notifications__readings_url_param: notification_readings_url(notification)
      }, &
  end

  private
    def notification_stream_tag
      turbo_stream_from Current.user, :notifications
    end

    def notification_tray_tag
      tag.div id: "notification-tray", class: "notification-tray", data: { turbo_permanent: true, controller: "notifications--readings" } do
        turbo_frame_tag("notifications", src: notifications_path)
      end
    end
end
