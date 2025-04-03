module NavigationHelper
  def link_to_home(icon: "home", label: "Home", **properties)
    classes = properties.delete(:class)

    link_to root_path, class: "btn #{classes}", data: { controller: "hotkey", action: "keydown.esc@document->hotkey#click" } do
      icon_tag(icon) + tag.span(label, class: "for-screen-reader")
    end
  end
end
