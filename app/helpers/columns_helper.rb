module ColumnsHelper
  def button_to_set_column(card, column)
    button_to \
      tag.span(column.name, class: "overflow-ellipsis"),
      card_triage_path(card, column_id: column),
      method: :post,
      class: [ "btn justify-start workflow-stage txt-uppercase", { "workflow-stage--current": column == card.column } ],
      form_class: "flex align-center gap-half",
      data: { turbo_frame: "_top" }
  end
end
