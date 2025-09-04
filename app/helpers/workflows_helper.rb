module WorkflowsHelper
  def button_to_set_stage(card, stage)
    button_to \
      tag.span(stage.name, class: "overflow-ellipsis"),
      card_staging_path(card, stage_id: stage),
      method: :put,
      class: [ "btn justify-start workflow-stage txt-uppercase", { "workflow-stage--current": stage == card.stage } ],
      form_class: "flex align-center gap-half",
      data: { turbo_frame: "_top" }
  end

  def stage_color(stage)
    stage.color.presence || Card::DEFAULT_COLOR
  end

  def dependent_collections_sentence(workflow)
    if workflow.collections.many?
      "It will be removed from #{ workflow.collections.count } collections that are using it."
    elsif workflow.collections.one?
      "It will be removed from the only collection using it."
    else
      "It's not being used in any collections."
    end
  end
end
