module FiltersHelper
  def filter_chip_tag(text, name:, value:)
    tag.button class: "btn txt-small btn--remove", data: { action: "filter-form#removeFilter form#submit", filter_form_target: "chip" } do
      concat hidden_field_tag(name, value, id: nil)
      concat tag.span(text)
      concat image_tag("close.svg", aria: { hidden: true }, size: 24)
    end
  end

  def filter_hidden_field_tag(key, value)
    is_collection = ->(key) { !Filter::Params::PERMITTED_PARAMS.include?(key.to_sym) }
    name = is_collection.(key) ? "#{key}[]".to_sym : key
    hidden_field_tag name, value, id: nil
  end
end
