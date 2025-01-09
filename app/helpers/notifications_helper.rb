module NotificationsHelper
  def notification_tray_tag
    tag.div class: "notification-tray" do
      turbo_frame_tag "notifications", src: notifications_path, data: { turbo_permanent: true }
    end
  end
end
