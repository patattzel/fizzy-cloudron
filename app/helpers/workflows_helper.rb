module WorkflowsHelper
  def link_to_stage_picker(bubble, workflow)
    link_to workflow.name, new_bucket_bubble_stage_picker_path(bubble.bucket, bubble, workflow_id: workflow.id)
  end

  def button_to_set_stage(bubble, stage)
    button_to stage.name, bucket_bubble_stagings_path(bubble.bucket, bubble, stage_id: stage.id),
      method: :post, class: [ "btn btn--small", { "fill-selected": stage == bubble.stage } ]
  end
end
