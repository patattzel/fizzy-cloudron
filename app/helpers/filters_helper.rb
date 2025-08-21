module FiltersHelper
  def filter_chip_tag(text, params)
    link_to cards_path(params), class: "btn txt-x-small btn--remove fill-selected flex-inline" do
      concat tag.span(text)
      concat icon_tag("close")
    end
  end

  def filter_hidden_field_tag(key, value)
    name = params[key].is_a?(Array) ? "#{key}[]" : key
    hidden_field_tag name, value, id: nil
  end

  def filter_selected_collections_title(user_filtering)
    user_filtering.selected_collection_titles.collect { tag.strong it }.to_sentence.html_safe
  end

  def filter_place_menu_item(path, label, icon)
    tag.li class: "popup__group", data: { filter_target: "item", navigable_list_target: "item" } do
      concat icon_tag(icon)
      concat(link_to(path, class: "popup__item btn") do
        concat tag.span(label, class: "overflow-ellipsis")
        concat tag.span(" ›", class: "translucent flex-item-no-shrink flex-item-justify-end")
      end)
    end
  end
end
