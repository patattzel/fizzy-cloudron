import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "collapsed" ]
  static targets = [ "column", "button" ]

  toggle({ target }) {
    const column = target.closest('[data-collapsible-columns-target="column"]')
    this.#toggleColumn(column);
  }

  preventToggle(event) {
    if (event.detail.attributeName === "class") {
      event.preventDefault()
    }
  }

  #toggleColumn(column) {
    this.#collapseAllExcept(column)

    if (this.#isCollapsed(column)) {
      this.#expand(column)
    } else {
      this.#collapse(column)
    }
  }

  #collapseAllExcept(clickedColumn) {
    this.columnTargets.forEach(column => {
      if (column !== clickedColumn) {
        this.#collapse(column)
      }
    })
  }

  #isCollapsed(column) {
    return column.classList.contains(this.collapsedClass)
  }

  #collapse(column) {
    this.#buttonFor(column).setAttribute("aria-expanded", "false")
    column.classList.add(this.collapsedClass)
  }

  #expand(column) {
    this.#buttonFor(column).setAttribute("aria-expanded", "true")
    column.classList.remove(this.collapsedClass)
  }

  #buttonFor(column) {
    return this.buttonTargets.find(button => column.contains(button))
  }
}
