module NotificationsHelper
  def notification_title(notification)
    title = notification.bubble.title

    if notification.resource.is_a? Comment
      "RE: " + title
    else
      title
    end
  end

  def notification_body(notification)
    name = notification.creator.name

    case notification.event.action
    when "assigned" then "#{name} assigned to you"
    when "published" then "Added by #{name}"
    when "popped" then "Popped by by #{name}"
    else name
    end
  end

  def notification_tag(notification, &)
    link_to notification.resource, id: dom_id(notification), class: "notification border-radius",
      data: { turbo_frame: "_top" }, &
  end
end
