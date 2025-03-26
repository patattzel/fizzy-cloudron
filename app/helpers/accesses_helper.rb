module AccessesHelper
  def access_menu_tag(bucket, &)
    tag.menu class: [ "flex flex-column gap margin-none pad txt-medium", { "toggler--toggled": bucket.all_access? } ], data: {
      controller: "filter toggle-class",
      filter_active_class: "filter--active", filter_selected_class: "selected",
      toggle_class_toggle_class: "toggler--toggled" }, &
  end

  def access_toggles_for(users, selected:)
    render partial: "buckets/access_toggle",
      collection: users, as: :user,
      locals: { selected: selected },
      cached: ->(user) { [ user, selected ] }
  end

  def access_involvement_advance_button(bucket, user)
    access = bucket.access_for(user)

    turbo_frame_tag dom_id(bucket, :involvement_button) do
      button_to bucket_involvement_path(bucket), method: :put, class: "btn", params: { involvement: next_involvement(access.involvement) } do
        image_tag("notification-bell-#{access.involvement.dasherize}.svg", aria: { hidden: true }, size: 24) +
          # TODO: should the screen reader label include the state we're in, or the state the button sets it to?
          tag.span("#{bucket.name} notification settings", class: "for-screen-reader")
      end
    end
  end

  private
    def next_involvement(involvement)
      order = %w[ access_only watching everything ]
      order[(order.index(involvement.to_s) + 1) % order.size]
    end
end
