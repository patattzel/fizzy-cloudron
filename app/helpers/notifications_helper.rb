module NotificationsHelper
  def notification_tray
    notification_stream_tag + notification_tray_tag
  end

  private
    def notification_stream_tag
      turbo_stream_from Current.user, :notifications
    end

    def notification_tray_tag
      tag.div id: "notification-tray", class: "notification-tray", data: { turbo_permanent: true } do
        turbo_frame_tag("notifications", src: notifications_path)
      end
    end
end
