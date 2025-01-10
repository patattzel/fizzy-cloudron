module NotificationsHelper
  def notification_tag(notification, &)
    link_to notification.resource, id: dom_id(notification), class: "notification",
      data: {
        turbo_frame: "_top",
        action: "turbo:click->notifications--readings#record",
        notifications__readings_url_param: notification_readings_url(notification)
      }, &
  end
end
