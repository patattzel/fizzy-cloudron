module Bubbles::AssignmentsHelper
  def bubble_assignee_checkbox(form, bubble, user)
    form.check_box("assignee_id[]", {
        checked: bubble.assigned_to?(user), data: { action: "change->form#submit" }, id: dom_id(user, :assign), include_hidden: false
      }, user.id
    ) + form.label("assignee_id[]", user.name, for: dom_id(user, :assign), class: "overflow-ellipsis")
  end
end
