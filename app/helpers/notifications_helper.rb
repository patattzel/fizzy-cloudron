module NotificationsHelper
  def notification_tray_tag
    tag.div id: "notification-tray", class: "notification-tray", data: { turbo_permanent: true } do
      turbo_frame_tag "notifications", src: notifications_path
    end
  end
end
