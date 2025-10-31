module CollectionsHelper
  def link_back_to_collection(collection)
    link_to collection, class: "header__title btn borderless txt-large",
      style: "--btn-padding: 0.25ch 1ch 0.25ch 0.75ch; view-transistion-name: card-collection-title;",
      data: { controller: "hotkey", action: "keydown.esc@document->hotkey#click click->turbo-navigation#backIfSamePath" } do
        tag.span ("&larr;" + tag.strong(collection.name, class: "font-black")).html_safe
    end
  end

  def link_to_edit_collection(collection)
    link_to edit_collection_path(collection), class: "btn", data: { controller: "tooltip" } do
      icon_tag("settings") + tag.span("Settings for #{collection.name}", class: "for-screen-reader")
    end
  end
end
