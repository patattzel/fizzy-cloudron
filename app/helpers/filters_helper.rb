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
end
