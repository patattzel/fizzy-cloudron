import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "column" ]

  toggle(event) {
    const clickedColumn = event.target.closest("[data-collapsible-columns-target='column']")

    if (!clickedColumn) return

    const isCurrentlyExpanded = clickedColumn.getAttribute("aria-expanded") === "true"

    this.columnTargets.forEach(column => {
      column.setAttribute("aria-expanded", "false")
    })

    if (!isCurrentlyExpanded) {
      clickedColumn.setAttribute("aria-expanded", "true")
    }
  }

  preventToggle(event) {
    if (event.detail.attributeName === "aria-expanded") {
      event.preventDefault()
    }
  }
}
