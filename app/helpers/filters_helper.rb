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

  def any_filters?(filter)
    filter.tags.any? || filter.assignees.any? || filter.creators.any? || filter.closers.any? ||
      filter.stages.any? || filter.terms.any? || filter.card_ids&.any? ||
      filter.assignment_status.unassigned? || !filter.indexed_by.latest?
  end
end
